//
//  LoginView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = LoginViewModel()
    @State private var goToRegister = false
    
    init() {
        _vm = StateObject(wrappedValue: LoginViewModel())
    }

    var body: some View {
        NavigationStack {
            Text("Login to\nDayChal")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 50)
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

                Button("Login") {
                    Task {
                        await vm.login(session: session)
                    }
                }
                .disabled(vm.isLoading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                if vm.isLoading {
                    ProgressView()
                }

                Spacer()

                HStack {
                    Spacer()
                    Text("Don't have account yet?")
                    Button("Register here") {
                        goToRegister = true
                    }
                    .foregroundColor(.blue)
                    Spacer()
                }
                .font(.footnote)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $goToRegister) {
                RegisterView()
            }
//            .navigationDestination(isPresented: $vm.isLoggedIn) {
//                MainTabView()
//            }
        }
    }
}
