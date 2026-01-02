//
//  ChallengeDetailView.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import SwiftUI

struct ChallengeDetailView: View {
    
    let challenge: Challenge
    let source: ChallengeSource
    let historyId: UUID?
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = ChallengeDetailViewModel()
    
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                Divider()
                descriptionSection
                Spacer(minLength: 40)
                                
                if vm.isLoading {
                    ProgressView("Processing...")
                        .frame(maxWidth: .infinity)
                } else {
                    actionSection
                }
            }
            .padding(24)
        }
        .navigationTitle("Challenge Detail")
        .sheet(isPresented: $showEditSheet) {
            CreateChallengeView(challengeToEdit: challenge)
        }
        .alert("Are you sure to delete this challenge?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                executeDelete()
            }
        } message: {
            Text("This challenge will be permanently removed.")
        }
    }
    
    private func executeDelete() {
        Task {
            try await SupabaseManager.shared.client.from("challenges")
                .delete().eq("id", value: challenge.id.uuidString).execute()
            dismiss()
        }
    }
}

private extension ChallengeDetailView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.challengeCategory.title)
                    .font(.caption.bold())
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1)).foregroundColor(.blue)
                    .cornerRadius(6)
                
                Text(challenge.challengeDifficulty.rawValue.capitalized)
                    .font(.caption.bold())
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(challenge.challengeDifficulty.color.opacity(0.1))
                    .foregroundColor(challenge.challengeDifficulty.color)
                    .cornerRadius(6)
            }
            
            Text(challenge.challengeName)
                .font(.largeTitle.bold())
            
            HStack {
                Label("\(challenge.chalPoin) Poin", systemImage: "star.fill")
                Spacer()
                Text("Created by \(challenge.creatorProfile?.username ?? "Unknown")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description").font(.headline)
            Text(challenge.challengeDescription)
                .lineSpacing(4)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    @ViewBuilder
    var actionSection: some View {
        switch source {
        case .home: homeActions
        case .historyOnGoing: historyActions
        case .myChallenge: creatorActions
        case .historyCompleted: completionStatus
        }
    }

    var homeActions: some View {
        Button(action: {
            Task {
                await vm.acceptChallenge(challengeId: challenge.id, userId: session.user!.id)
                dismiss()
            }
        }) {
            Text("Accept Challenge").frame(maxWidth: .infinity).bold()
        }.buttonStyle(.borderedProminent)
    }

    var historyActions: some View {
        Button(action: {
            guard let userId = session.user?.id else { return }
            
            guard let id = historyId else {
                print("DEBUG: historyId is nil, cannot complete challenge")
                return
            }
            
            Task {
                await vm.completeChallenge(
                    historyId: id,
                    userId: userId,
                    earnPoint: challenge.chalPoin
                )
                await session.refreshProfile()
                dismiss()
            }
        }) {
            if vm.isLoading {
                ProgressView().tint(.white)
            } else {
                Text("Complete Challenge").frame(maxWidth: .infinity).bold()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .controlSize(.large)
        .disabled(vm.isLoading)
    }

    var creatorActions: some View {
        HStack(spacing: 12) {
            Button("Edit") {
                showEditSheet = true
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)

            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Text("Delete").frame(maxWidth: .infinity).bold()
            }.buttonStyle(.borderedProminent)
        }
    }

    var completionStatus: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text("This challenge has been completed")
        }
        .frame(maxWidth: .infinity).padding().background(Color.green.opacity(0.1))
        .foregroundColor(.green).cornerRadius(12)
    }
}
