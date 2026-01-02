//
//  RegisterView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Text("Welcome,\nNew Challenger!")
        
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        
        VStack(alignment: .leading, spacing: 20) {
            // Email
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                TextField("Enter your email", text: $vm.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                if let error = vm.emailError {
                    Text(error).font(.caption).foregroundColor(.red)
                }
            }

            // Password
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                SecureField("Enter your password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                if let error = vm.passwordError {
                    Text(error).font(.caption).foregroundColor(.red)
                }
            }

            // Confirm Password
            VStack(alignment: .leading, spacing: 6) {
                Text("Confirm Password")
                SecureField("Confirm your password", text: $vm.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                if let error = vm.confirmPasswordError {
                    Text(error).font(.caption).foregroundColor(.red)
                }
            }

            Button("Register") {
                Task { await vm.register() }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()

            HStack {
                Spacer()
                Text("Already have account yet?")
                Button("Login here") {
                    dismiss()
                }
                .foregroundColor(.blue)
                Spacer()
            }
            .font(.footnote)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .onChange(of: vm.isRegistered) {
            if vm.isRegistered {
                dismiss()
            }
        }
    }
}
