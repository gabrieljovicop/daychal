//
//  RegisterViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    
    @Published var isRegistered = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func register() async {
        resetErrors()
        isLoading = true

        guard email.contains("@") else {
            emailError = "Invalid email format"
            isLoading = false
            return
        }

        guard password.count >= 6 else {
            passwordError = "Password must be at least 6 characters"
            isLoading = false
            return
        }

        guard password == confirmPassword else {
            confirmPasswordError = "Password does not match"
            isLoading = false
            return
        }

        do {
            try await authService.register(email: email, password: password)
//            try await authService.login(email: email, password: password)
            isRegistered = true
        } catch {
            let description = error.localizedDescription
            if description.contains("user already exists") || description.contains("A user with this email address has already been registered") {
                emailError = "Email already registered"
            } else {
                emailError = "Failed to register: \(description)"
            }
        }
        isLoading = false
    }

    private func resetErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        errorMessage = nil
    }
}
