//
//  AuthController.swift
//  BedSolution
//
//  Created by 이재호 on 8/2/25.
//

import Foundation
import Logging
import Supabase

@Observable
class AuthController {
    static let shared = AuthController()
    
    private(set) var username: String = ""
    private(set) var email: String = ""
    private(set) var isSignIn: Bool = false
    private let logger: Logger
    private let client: SupabaseClient
    private let patientRepository = PatientRepository()
    private(set) var patients: [Patient] = []
    
    private init() {
        logger = Logger(label: "AuthController")
        guard let supabaseURL = APIConfiguration.shared.baseURL,
              let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("Auth Configuration Error: Missing Supabase URL or API Key")
        }
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: apiKey)
        _listenUserSession()
    }
    
    func getUID() -> UUID? {
        client.auth.currentUser?.id
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
    
    func isPatientRegistered() async -> Bool {
        guard let uid = client.auth.currentUser?.id else {
            logger.error("User not signed in")
            return false
        }
        do {
            let count = try await patientRepository.count(filter: .init(uid: uid))
            return count > 0
        } catch {
            logger.error("Fail to get patient count: \(error)")
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
            try await patientRepository.upsert(
                Patient(
                    id: nil, createdAt: Date.now, updatedAt: nil, uid: uid,
                    name: name, height: nil, weight: Float(weight),
                    cautionOcciput: cautionOcciput, cautionScapula: cautionScapula, cautionElbow: cautionElbow, cautionHip: cautionHip, cautionHeel: cautionHeel
                )
            )
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
                    self.isSignIn = await self.isPatientRegistered()
                    self.email = user.email ?? ""
                } else {
                    self.isSignIn = false
                    self.email = ""
                }
            }
        }
    }
}
