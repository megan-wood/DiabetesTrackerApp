//
//  AuthViewModel.swift
//  DiabetesTracker
//
//  Created by Megan on 11/20/25.
//

import SwiftUI
import Supabase

// since this file holds information on what to render (based on whether user is logged in or not), make usre that this code executes on the main thread to ensure concurrency
@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false  // when value changes, notification signal to observing views or subscribers to update
    
    private let client = SupabaseService.shared.client
    
    init() {
        Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        let session = try? await client.auth.session
        isLoggedIn = (session != nil)
    }
    
    func signIn(email: String, password: String) async {
        do {
            try await client.auth.signIn(email: email, password: password)
            isLoggedIn = true
        } catch {
            print("Login error:", error)
        }
    }
    
    func signOut() async {
        do {
            try await client.auth.signOut()
            isLoggedIn = false
        } catch {
            print("Logout error:", error)
        }
    }
}
