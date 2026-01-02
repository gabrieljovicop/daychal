//
//  CreateChallengeView.swift
//  DayChal
//
//  Created by prk on 18/12/25.
//

import SwiftUI

struct CreateChallengeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = CreateChallengeViewModel()
    
    let challengeToEdit: Challenge?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Challenge Info") {
                    TextField("Title", text: $vm.title)
                    TextField("Description", text: $vm.description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Settings") {
                    HStack {
                        Text("Reward Points")
                        Spacer()
                        Text("\(vm.selectedDifficulty.chalPoin) Poin")
                            .bold()
                            .foregroundColor(.orange)
                    }
                    
                    Picker("Category", selection: $vm.selectedCategory) {
                        ForEach(ChallengeCategory.allCases.filter { $0 != .all }) { cat in
                            Text(cat.title).tag(cat)
                        }
                    }

                    Picker("Difficulty", selection: $vm.selectedDifficulty) {
                        ForEach(ChallengeDifficulty.allCases) { diff in
                            HStack {
                                Image(systemName: "circle.fill").foregroundStyle(diff.color)
                                Text(diff.rawValue.capitalized)
                            }.tag(diff)
                        }
                    }
                }
                
                Button(action: {
                    Task { await vm.saveChallenge(userId: session.user!.id, editingId: challengeToEdit?.id) }
                }) {
                    if vm.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text(challengeToEdit == nil ? "Create Challenge" : "Save Changes").bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .disabled(vm.isLoading || vm.title.isEmpty)
                .listRowBackground(vm.title.isEmpty ? Color.gray : Color.black)
                .foregroundColor(.white)
            }
            .navigationTitle(challengeToEdit == nil ? "New Challenge" : "Edit Challenge")
            .onAppear {
                if let challenge = challengeToEdit { vm.setupEditMode(with: challenge) }
            }
            .alert("Success!", isPresented: $vm.showSuccessAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text(challengeToEdit == nil ? "Created successfully." : "Updated successfully.")
            }
        }
    }
}
