//
//  CreateChallengeViewModel.swift
//  DayChal
//
//  Created by prk on 18/12/25.
//

import Foundation

@MainActor
class CreateChallengeViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var points = ""
    @Published var selectedCategory: ChallengeCategory = .sport
    @Published var selectedDifficulty: ChallengeDifficulty = .medium
    @Published var isLoading = false
    @Published var showSuccessAlert = false
    
    func setupEditMode(with challenge: Challenge) {
        title = challenge.challengeName
        description = challenge.challengeDescription
        points = String(challenge.chalPoin)
        selectedCategory = challenge.challengeCategory
        selectedDifficulty = challenge.challengeDifficulty
    }
    
    func saveChallenge(userId: UUID, editingId: UUID?) async {
        isLoading = true
        defer { isLoading = false }
        
        let autoPoints = selectedDifficulty.chalPoin
        
        let request = ChallengeInsertRequest(
            creator_id: userId,
            challenge_name: title,
            challenge_description: description,
            challenge_category: selectedCategory.rawValue,
            challenge_difficulty: selectedDifficulty.rawValue,
            chal_poin: autoPoints
        )
        
        do {
            let query = SupabaseManager.shared.client.from("challenges")
            if let id = editingId {
                try await query.update(request).eq("id", value: id.uuidString).execute()
            } else {
                try await query.insert(request).execute()
            }
            showSuccessAlert = true
        } catch {
            print("Save Error: \(error)")
        }
    }
}
