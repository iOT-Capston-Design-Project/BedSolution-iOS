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
    
    private init() {
        logger = Logger(label: "AuthController")
        guard let supabaseURL = APIConfiguration.shared.baseURL,
              let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("Auth Configuration Error: Missing Supabase URL or API Key")
        }
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: apiKey)
        _listenUserSession()
    }
    
    func signInWithApple(idToken: String, username: String?) async -> Bool {
        do {
            let session = try await client.auth.signInWithIdToken(credentials: OpenIDConnectCredentials(provider: .apple, idToken: idToken))
            if let username {
                _ = try? await client.auth.update(user: UserAttributes(data: ["username": .string(username)]))
            }
            return true
        } catch {
            logger.error("Failed to sign in with Apple: \(error)")
            return false
        }
    }
    
    func isPatientExit() async -> Bool {
        guard let uid = client.auth.currentUser?.id else {
            logger.error("User not signed in")
            return false
        }
        do {
            let result = try await client.from("patients")
                .select(head: true, count: CountOption.planned)
                .eq("uid", value: uid)
                .execute()
                .count ?? 0
            return result > 0
        } catch {
            logger.error("Fail to get patient: \(error)")
            return false
        }
    }
    
    func isDeviceExit() async -> Bool {
        UserDefaults.standard.integer(forKey: "device_id") != 0
    }
    
    private func _listenUserSession() {
        Task {
            for await (event, session) in client.auth.authStateChanges {
                self.logger.info("User session changed: \(event)")
                self.isSignIn = session?.user != nil
                if let user = session?.user {
                    self.username = user.userMetadata["username"]?.stringValue ?? ""
                    self.email = user.email ?? ""
                } else {
                    self.username = ""
                    self.email = ""
                }
            }
        }
    }
}
