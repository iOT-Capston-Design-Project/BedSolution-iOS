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
    
    func stream(filter: Filter?) -> AsyncStream<Heatmap> {
        guard let deviceID = filter?.deviceID else {
            logger.warning("stream called without device id; returning empty sequence")
            return AsyncStream<Heatmap> { continuation in continuation.finish() }
        }
        
        let channel = client.channel(String(deviceID))
        return AsyncStream<Heatmap> { continuation in
            Task {
                do {
                    try await channel.subscribeWithError()
                    logger.info("Heatmap channel subscribed")
                    continuation.yield(Heatmap(sensors: []))
                    for await msg in channel.broadcastStream(event: "heatmap_update") {
                        if let heatmap = try? msg["payload"]?.objectValue?.decode(as: Heatmap.self) {
                            logger.info("Heatmap updated")
                            continuation.yield(heatmap)
                        }
                    }
                } catch {
                    logger.error("Heatmap channel subscribe error: \(String(describing: error))")
                }
                continuation.finish()
            }
            
            continuation.onTermination = { _ in
                Task {
                    await channel.unsubscribe()
                }
            }
        }
    }
}

