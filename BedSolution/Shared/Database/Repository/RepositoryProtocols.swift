//
//  RepositoryProtocols.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation

protocol ReadRepository {
    associatedtype Element = Identifiable
    associatedtype Filter
    
    var table: String { get }
    
    func get(filter: Filter?) async throws -> Element?
    
    func list(filter: Filter?, limit: Int?) async throws -> [Element]
    
    func count(filter: Filter?) async throws -> Int
}

protocol RWRepository: ReadRepository {
    func upsert(_ element: Element) async throws -> Data
}
