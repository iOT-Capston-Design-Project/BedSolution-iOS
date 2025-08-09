//
//  AuthController.swift
//  BedSolution
//
//  Created by 이재호 on 8/2/25.
//

import Foundation
import Logging
import Supabase

private struct PatientDTO: Encodable, Sendable {
    let uid: UUID
    let name: String
    let weight: Int
    let caution_occiput: Bool
    let caution_scapula: Bool
    let caution_elbow: Bool
    let caution_hip: Bool
    let caution_heel: Bool

    private enum CodingKeys: String, CodingKey {
        case uid, name, weight
        case caution_occiput, caution_scapula, caution_elbow, caution_hip, caution_heel
    }

    // Make the Encodable conformance nonisolated so it can satisfy a Sendable generic requirement.
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encode(weight, forKey: .weight)
        try container.encode(caution_occiput, forKey: .caution_occiput)
        try container.encode(caution_scapula, forKey: .caution_scapula)
        try container.encode(caution_elbow, forKey: .caution_elbow)
        try container.encode(caution_hip, forKey: .caution_hip)
        try container.encode(caution_heel, forKey: .caution_heel)
    }
}

@Observable
class AuthController {
    static let shared = AuthController()
    
    private(set) var username: String = ""
    private(set) var email: String = ""
    private(set) var isSignIn: Bool = false
    private let logger: Logger
    private let client: SupabaseClient
    
    private init() {
        logger = Logger(label: "AuthController")
        guard let supabaseURL = APIConfiguration.shared.baseURL,
              let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("Auth Configuration Error: Missing Supabase URL or API Key")
        }
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: apiKey)
        _listenUserSession()
    }
    
    func signin(email: String, password: String) async -> Bool {
        do {
            _ = try await client.auth.signIn(email: email, password: password)
            return true
        } catch {
            logger.error("Failed to sign in: \(error)")
            return false
        }
    }
    
    func signup(email: String, password: String) async -> Bool {
        do {
            _ = try await client.auth.signUp(email: email, password: password)
            return true
        } catch {
            logger.error("Failed to sign up: \(error)")
            return false
        }
    }
    
    func loadPatient() async -> Bool {
        guard let uid = client.auth.currentUser?.id else {
            logger.error("User not signed in")
            return false
        }
        do {
            let result = try await client.from("patients")
                .select()
                .eq("uid", value: uid)
                .execute()
            // TODO: Implement updating patient info
            return (result.count ?? 0) > 0
        } catch {
            logger.error("Fail to get patient: \(error)")
            return false
        }
    }
    
    func registerPatient(
        name: String, weight: Int,
        cautionOcciput: Bool, cautionScapula: Bool,
        cautionElbow: Bool, cautionHip: Bool, cautionHeel: Bool
    ) async -> Bool {
        guard let uid = client.auth.currentUser?.id else {
            logger.error("User not signed in")
            return false
        }
        do {
            let dto = PatientDTO(
                uid: uid,
                name: name,
                weight: weight,
                caution_occiput: cautionOcciput,
                caution_scapula: cautionScapula,
                caution_elbow: cautionElbow,
                caution_hip: cautionHip,
                caution_heel: cautionHeel
            )
            _ = try await client.from("patients")
                .insert(dto)
                .execute()
            return true
        } catch {
            logger.error("Fail to register patient: \(error)")
            return false
        }
    }
    
    private func _listenUserSession() {
        Task {
            for await (event, session) in client.auth.authStateChanges {
                self.logger.info("User session changed: \(event)")
                if let user = session?.user {
                    self.isSignIn = await self.loadPatient()
                    self.email = user.email ?? ""
                } else {
                    self.isSignIn = false
                    self.email = ""
                }
            }
        }
    }
}
