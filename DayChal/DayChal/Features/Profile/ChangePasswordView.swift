//
//  ChangePasswordView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct ChangePasswordView: View {

    @Environment(\.dismiss) var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMsg: String?

    @ObservedObject var vm: ProfileViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Secure your account with a new password.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            SecureField("New Password", text: $newPassword)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Confirm New Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)

            if let error = errorMsg {
                Text(error).foregroundColor(.red).font(.caption)
            }

            Button {
                if newPassword == confirmPassword && newPassword.count >= 6 {
                    Task {
                        await vm.changePassword(newPassword: newPassword)
                    }
                } else {
                    errorMsg = "Passwords don't match or too short"
                }
            } label: {
                if vm.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Update Password").bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(newPassword.isEmpty || vm.isLoading ? Color.gray : Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(newPassword.isEmpty || vm.isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showAlert) {
            Button("OK") {
                if vm.alertTitle == "Success" {
                    dismiss()
                }
            }
        } message: {
            Text(vm.alertMessage)
        }
    }
}
