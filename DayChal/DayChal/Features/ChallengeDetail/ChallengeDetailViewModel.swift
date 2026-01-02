//
//  ChallengeDetailViewModel.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

@MainActor
final class ChallengeDetailViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let historyService: ChallengeHistoryServiceProtocol

    init(
        historyService: ChallengeHistoryServiceProtocol = ChallengeHistoryService()
    ) {
        self.historyService = historyService
    }

    func acceptChallenge(
        challengeId: UUID,
        userId: UUID
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await historyService.acceptChallenge(
                userId: userId,
                challengeId: challengeId
            )
        } catch {
            errorMessage = "Failed to accept challenge"
        }
    }
    
    func completeChallenge(
        historyId: UUID,
        userId: UUID,
        earnPoint: Int
    ) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await historyService.completeChallenge(
                historyId: historyId,
                userId: userId,
                earnPoint: earnPoint
            )
        } catch {
            errorMessage = "Failed to complete challenge"
        }
    }
}
