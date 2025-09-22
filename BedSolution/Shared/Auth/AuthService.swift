//
//  AuthService.swift
//  BedSolution
//
//  Created by 이재호 on 9/3/25.
//

import Foundation
import Logging
import Supabase

@Observable
final class AuthService {
    private(set) var state: AuthState = .loading
    private let logger = Logger(label: "AuthService")
    private let client = SupabaseService.shared.client
    private(set) var uid: UUID?
    
    init() {
        _listenSession()
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
            logger.error("Failed to sign in: \(error)")
            return false
        }
    }
    
    @discardableResult
    func signout() async -> Bool {
        do {
            _ = try await client.auth.signOut()
            return true
        } catch {
            logger.error("Failed to sign out: \(error)")
            return false
        }
    }
    
    func _listenSession() {
        Task {
            for await (event, session) in client.auth.authStateChanges {
                self.logger.info("User session changed: \(event)")
                if let user = session?.user {
                    self.uid = user.id
                    self.state = .loggedIn
                } else {
                    self.state = .loggedOut
                }
            }
        }
    }
}
