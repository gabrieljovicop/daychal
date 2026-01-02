//
//  HistoryViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    
    @Published var allHistories: [HistoryItem] = []
    @Published var selectedStatus: HistoryStatus = .onGoing
    @Published var isLoading = false


    private let historyService: HistoryServiceProtocol
    private let challengeHistoryService: ChallengeHistoryServiceProtocol

    init(
        historyService: HistoryServiceProtocol = HistoryService(),
        challengeHistoryService: ChallengeHistoryServiceProtocol = ChallengeHistoryService(),
        initialStatus: HistoryStatus = .onGoing
    ) {
        self.historyService = historyService
        self.challengeHistoryService = challengeHistoryService
        self.selectedStatus = initialStatus
    }
    
    var filteredHistory: [HistoryItem] {
        allHistories.filter { $0.status == selectedStatus }
    }
    
    func loadHistory(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetchedItems = try await historyService.fetchHistory(userId: userId)
            self.allHistories = fetchedItems
        } catch {
            print("Fetch history error:", error)
        }
    }
    
    func refresh(userId: UUID, status: HistoryStatus) async {
        await loadHistory(userId: userId)
    }
    
    func completeChallenge (
        historyId: UUID,
        userId: UUID,
        earnPoint: Int
    ) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await challengeHistoryService.completeChallenge(
                historyId: historyId,
                userId: userId,
                earnPoint: earnPoint
            )
            await loadHistory(userId: userId)
        } catch {
            print("Complete challenge error:", error)
        }
    }
}
