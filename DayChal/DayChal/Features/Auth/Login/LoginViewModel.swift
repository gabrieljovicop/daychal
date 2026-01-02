//
//  LoginViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""

    @Published var emailError: String?
    @Published var passwordError: String?
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
//    @Published var isLoggedIn = false

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func login(session: SessionManager) async {
        resetErrors()
        isLoading = true

        guard email.contains("@") else {
            emailError = "Invalid email format"
            return
        }

        guard password.count >= 6 else {
            passwordError = "Password must be at least 6 characters"
            return
        }

        do {
            try await authService.login(email: email, password: password)
            isAuthenticated = true
//            isLoggedIn = true
        } catch {
            let description = error.localizedDescription
            if description.contains("Invalid login credentials") || description.contains("Invalid email or password") {
                emailError = "Invalid email or password. Please try again."
            } else {
                errorMessage = "Login failed: \(description)"
            }
        }
        isLoading = false
    }

    private func resetErrors() {
        emailError = nil
        passwordError = nil
        errorMessage = nil
    }
}
