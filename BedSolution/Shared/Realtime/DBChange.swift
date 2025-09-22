//
//  DBChange.swift
//  BedSolution
//
import Foundation

enum DBAction {
    case inserted
    case updated
    case deleted
}

struct DBChange<T: Decodable>: Sendable {
    let action: DBAction
    let record: T
}

