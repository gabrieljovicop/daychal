//
//  ProfileView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI
import Supabase

struct ProfileView: View {

    @EnvironmentObject var session: SessionManager
    @StateObject private var vm: ProfileViewModel

    init(user: User?, profile: Profile?) {
        _vm = StateObject(wrappedValue: ProfileViewModel(user: user, profile: profile))
    }

    var body: some View {
        VStack(spacing: 24) {

            VStack(alignment: .leading, spacing: 12) {
                Text("Username")
                    .font(.caption).foregroundColor(.gray)
                
                TextField("Username", text: $vm.username)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!vm.isEditing)

                Text("Email")
                    .font(.caption).foregroundColor(.gray)
                Text(vm.email)
                    .foregroundColor(.secondary)
            }

            Button {
                if vm.isEditing {
                    Task {
                        await vm.saveUsername(userId: session.user!.id)
                        await session.refreshProfile()
                    }
                } else {
                    vm.isEditing.toggle()
                }
            } label: {
                Group {
                    if vm.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text(vm.isEditing ? "Save Changes" : "Edit Profile")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.isEditing ? .green : .black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            Button {
                vm.showPasswordSheet = true
            } label: {
                Text("Change Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black)
                    )
            }

            Button {
                Task { await session.logout() }
            } label: {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding(24)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert(vm.alertTitle, isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.alertMessage)
        }
        .sheet(isPresented: $vm.showPasswordSheet) {
            ChangePasswordView(vm: vm)
        }
        .onChange(of: session.profile) { oldProfile, newProfile in
            guard let newProfile else { return }
            vm.username = newProfile.username
        }
    }
}
