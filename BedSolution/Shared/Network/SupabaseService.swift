//
//  SupabaseService.swift
//  BedSolution
//
//  Centralized Supabase client and JSON decoder/formatters.
//

import Foundation
import Supabase
import Logging

final class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient
    let jsonDecoder: JSONDecoder
    let logger = Logger(label: "SupabaseService")

    // Date formatters
    let dateOnlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    let iso8601Fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()

    let iso8601NoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()

    private init() {
        guard let baseURL = APIConfiguration.shared.baseURL,
              let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("SupabaseService: Missing BASE URL or API KEY")
        }

        self.client = SupabaseClient(supabaseURL: baseURL, supabaseKey: apiKey)

        let decoder = JSONDecoder()
        // Robust date decoding: try yyyy-MM-dd -> ISO8601(fractional) -> ISO8601 -> unix seconds
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            if let str = try? container.decode(String.self) {
                if let d = SupabaseService.shared.dateOnlyFormatter.date(from: str) {
                    return d
                }
                if let d = SupabaseService.shared.iso8601Fractional.date(from: str) {
                    return d
                }
                if let d = SupabaseService.shared.iso8601NoFractional.date(from: str) {
                    return d
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date string: \(str)")
            }

            if let secs = try? container.decode(Double.self) {
                return Date(timeIntervalSince1970: secs)
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date value")
        }
        self.jsonDecoder = decoder
    }

    func formatDateOnly(_ date: Date) -> String { dateOnlyFormatter.string(from: date) }
}

