//
//  AuthService.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Supabase

enum AuthError: Error {
    case unknown
}

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
}

final class AuthService: AuthServiceProtocol {

    private let client = SupabaseManager.shared.client

    func login(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    func register(email: String, password: String) async throws {
        
        try await client.auth.signUp(
                email: email,
                password: password
        )

//        let response = try await client.auth.signUp(
//            email: email,
//            password: password
//        )
//
//        let user = response.user
//        let username = email.components(separatedBy: "@").first ?? "user"

//        let profile = ProfileInsert(
//             id: user.id,
//             email: email,
//             username: username,
//             my_chal_poin: 0
//         )

//         try await client.from("profiles").insert(profile).execute()
    }

//    func register(email: String, password: String) async throws {
//        try await client.auth.signUp(
//            email: email,
//            password: password
//        )
//    }
}
