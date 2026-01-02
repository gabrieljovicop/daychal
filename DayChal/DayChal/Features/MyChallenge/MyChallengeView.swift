//
//  MyChallengeView.swift
//  DayChal
//
//  Created by prk on 18/12/25.
//

import SwiftUI

struct MyChallengeView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = MyChallengeViewModel()
    @State private var showCreateSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if vm.isLoading {
                    ProgressView().padding(.top, 50)
                } else if vm.myChallenges.isEmpty {
                    ContentUnavailableView {
                        Label("No Challenges Yet", systemImage: "plus.square.dashed")
                    } description: {
                        Text("Start creating your own challenges to inspire others.")
                    } actions: {
                        Button("Create Now") { showCreateSheet = true }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(vm.myChallenges) { challenge in
                        ChallengeRow(challenge: challenge, source: .myChallenge)
                    }
                }
            }
            .padding(24)
        }
        .navigationTitle("My Challenges")
        .toolbar {
            Button { showCreateSheet = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showCreateSheet, onDismiss: {
            loadData()
        }) {
            CreateChallengeView(challengeToEdit: nil)
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        Task { await vm.fetchMyChallenges(userId: session.user!.id) }
    }
}
