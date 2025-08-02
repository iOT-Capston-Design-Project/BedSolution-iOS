//
//  APIConfiguration.swift
//  BedSolution
//
//  Created by 이재호 on 7/28/25.
//

import Foundation
import Logging

class APIConfiguration {
    private(set) var baseURL: URL?
    private(set) var apiKey: String?
    private let logger: Logger
    static let shared = APIConfiguration()
    
    init() {
        self.logger = Logger(label: "BedSolution API Configuration")
        if !load() {
            logger.error("Fail to load API configuration")
        }
    }
    
    func load() -> Bool {
        guard baseURL == nil || apiKey == nil else { return true }
        guard let apiURL = URL(string: "http://34.30.146.175:8000"),
              let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            logger.error("API configuration is missing")
            return false
        }
        self.apiKey = apiKey
        self.baseURL = apiURL
        logger.info("API configuration loaded successfully (baseURL: \(apiURL))")
        return true
    }
}
