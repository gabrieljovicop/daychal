//
//  ProfileViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation
import Supabase

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var email: String = ""
    @Published var isEditing = false
    @Published var showPasswordSheet = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    
    @Published var isLoading = false

    private let client = SupabaseManager.shared.client

    init(user: User?, profile: Profile?) {
        self.email = user?.email ?? ""
        self.username = profile?.username ?? ""
    }
    
    func triggerAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }

    func saveUsername(userId: UUID) async {
        guard !username.isEmpty else { return }
        isLoading = true
        
        do {
            try await client
                .from("profiles")
                .update(["username": username])
                .eq("id", value: userId.uuidString)
                .execute()
            
            isEditing = false
            triggerAlert(title: "Success", message: "Username has been updated.")
        } catch {
            print("Update username error: \(error)")
            triggerAlert(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }

    func changePassword(newPassword: String) async {
        isLoading = true
        do {
            try await client.auth.update(
                user: UserAttributes(password: newPassword)
            )
            triggerAlert(title: "Success", message: "Password has been changed successfully.")
        } catch {
            triggerAlert(title: "Error", message: error.localizedDescription)
        }
    }
}
