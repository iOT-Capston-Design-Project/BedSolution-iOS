//
//  HeatmapRepository.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation
import Logging
import Supabase

final class HeatmapRepository: StreamRepository {
    typealias Element = Heatmap
    
    struct Filter {
        var deviceID: Int
    }
    
    let table: String = "heatmaps"
    private let client = SupabaseService.shared.client
    private let logger = Logger(label: "HeatmapRepository")
    
    init() {}
    
    func get(filter: Filter?) async throws -> Heatmap? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter).limit(1).execute()
        logger.info("Get response: \(response.response.statusCode)")
        logger.debug("JSON: \(String(data: response.data, encoding: .utf8) ?? "<nil>")")
        return try SupabaseService.shared.jsonDecoder.decode([Heatmap].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [Heatmap] {
        logger.warning("Not supported in Heatmap")
        return []
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        let response = try await buildFilter(filter, head: true).execute()
        logger.info("Get response: \(response.response.statusCode)")
        return response.count ?? 0
    }
    
    func stream(filter: Filter?) -> AsyncStream<Heatmap> {
        guard let deviceID = filter?.deviceID else {
            logger.warning("stream called without device id; returning empty sequence")
            return AsyncStream { continuation in continuation.finish() }
        }
        
        let channel = client.channel("heatmaps-\(deviceID)")

        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: table)
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: table)

            let insertionTask = Task {
                for await insertion in insertions {
                    let row = insertion.record
                    guard let idValue = row[Heatmap.CodingKeys.deviceID.rawValue]?.rawValue as? Int,
                          idValue == deviceID,
                          let decoded = Heatmap(row: row) else { continue }
                    continuation.yield(decoded)
                }
            }

            let updateTask = Task {
                for await update in updates {
                    let row = update.record
                    guard let idValue = row[Heatmap.CodingKeys.deviceID.rawValue]?.rawValue as? Int,
                          idValue == deviceID,
                          let decoded = Heatmap(row: row) else { continue }
                    continuation.yield(decoded)
                }
            }

            let currentFilter = filter
            Task { [currentFilter] in
                do {
                    if let initial = try await self.get(filter: currentFilter) {
                        continuation.yield(initial)
                    }
                } catch {
                    self.logger.error("Failed to fetch initial heatmap: \(error.localizedDescription)")
                }
            }

            Task {
                do {
                    try await channel.subscribeWithError()
                } catch {
                    self.logger.error("heatmaps subscribe failed: \(error.localizedDescription)")
                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in
                insertionTask.cancel()
                updateTask.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false, count: CountOption = .exact) -> PostgrestFilterBuilder {
        return client.from(table).select(head: head, count: head ? count: nil).eq(Heatmap.CodingKeys.deviceID.rawValue, value: filter.deviceID)
    }
}
