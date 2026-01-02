//
//  HistoryView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject private var vm = HistoryViewModel()
    @EnvironmentObject var session: SessionManager
    init() {}
    
    var body: some View {
        VStack(spacing: 0) {
            statusPicker
            if vm.isLoading && vm.allHistories.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.filteredHistory.isEmpty {
                emptyState
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                historyList
            }
        }
        .navigationTitle("History")
        .onAppear {
            if let userId = session.user?.id {
                Task {
                    await vm.loadHistory(userId: userId)
                }
            }
        }
    }
}

private extension HistoryView {
    var statusPicker: some View {
        Picker("Status", selection: $vm.selectedStatus) {
            Text("On Going").tag(HistoryStatus.onGoing)
            Text("Completed").tag(HistoryStatus.completed)
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    var emptyState: some View {
        ContentUnavailableView {
            if vm.selectedStatus == .onGoing {
                Label("There are no ongoing challenges", systemImage: "figure.walk")
            } else {
                Label("No challenges have been completed yet", systemImage: "trophy")
            }
        } description: {
            Text(vm.selectedStatus == .onGoing ?
                 "Take the challenge at Home to start your journey!" :
                 "Complete the current challenge to see the history here.")
        }
        .frame(maxHeight: .infinity)
    }

    var historyList: some View {
        List(vm.filteredHistory) { history in
            ChallengeRow(
                challenge: history.challenge,
                source: vm.selectedStatus == .onGoing ? .historyOnGoing : .historyCompleted,
                dateInfo: vm.selectedStatus == .onGoing ? history.acceptedAt : history.completedAt,
                historyId: history.id
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
        .refreshable {
            if let userId = session.user?.id {
                await vm.loadHistory(userId: userId)
            }
        }
    }
}
