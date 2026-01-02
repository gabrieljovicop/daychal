//
//  HomeViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    var session: SessionManager?
    
    @Published var username: String = ""
    @Published var myChalPoin: Int = 0
    
    private var allChallenges: [Challenge] = []

    @Published var selectedCategory: ChallengeCategory = .all
    @Published var selectedDifficulty: ChallengeDifficulty? = nil
    @Published var categories: [ChallengeCategory] = ChallengeCategory.allCases
    @Published var isLoading: Bool = false
    
    func getFilteredChallenges(ongoingIds: [UUID]) -> [Challenge] {
        allChallenges.filter { challenge in
            let isNotTaken = !ongoingIds.contains(challenge.id)
            let categoryMatch = selectedCategory == .all || challenge.challengeCategory.id == selectedCategory.id
            let difficultyMatch = selectedDifficulty == nil || challenge.challengeDifficulty == selectedDifficulty
            
            return isNotTaken && categoryMatch && difficultyMatch
        }
    }
    
    private let challengeService: ChallengeServiceProtocol
    private let challengeHistoryService:ChallengeHistoryServiceProtocol

    init(
        challengeService: ChallengeServiceProtocol = ChallengeService(),
        challengeHistoryService: ChallengeHistoryServiceProtocol = ChallengeHistoryService()
    ) {
        self.challengeService = challengeService
        self.challengeHistoryService = challengeHistoryService
    }
    
    func bindProfile(_ profile: Profile?) {
        guard let profile else { return }
        self.username = profile.username
        self.myChalPoin = profile.myChalPoin
    }

    func loadChallenges() async {
        if allChallenges.isEmpty { isLoading = true }
        defer { isLoading = false }
        
        do {
            let fetched: [Challenge] = try await SupabaseManager.shared.client
                .from("challenges")
                .select("*, profiles(username)")
                .execute()
                .value
            
            self.allChallenges = fetched
        } catch {
            print("Error fetch challenges: \(error)")
        }
    }
    
    func acceptChallenge(
        challengeId: UUID,
        userId: UUID
    ) async {
        do {
            try await challengeHistoryService.acceptChallenge(
                userId: userId,
                challengeId: challengeId
            )
        } catch {
            print("Accept challenge error:", error)
        }
    }
}
