//
//  MyChallengeViewModel.swift
//  DayChal
//
//  Created by prk on 18/12/25.
//

import Foundation
import Supabase

@MainActor
final class MyChallengeViewModel: ObservableObject {
    @Published var myChallenges: [Challenge] = []
    @Published var isLoading = false
    
    private let client = SupabaseManager.shared.client
    
    func fetchMyChallenges(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            myChallenges = try await client
                .from("challenges")
                .select()
                .eq("creator_id", value: userId.uuidString)
                .execute()
                .value
        } catch {
            print("Error fetch my challenges: \(error)")
        }
    }
    
    func deleteChallenge(challengeId: UUID, userId: UUID) async {
        do {
            try await client
                .from("challenges")
                .delete()
                .eq("id", value: challengeId.uuidString)
                .execute()
            
            await fetchMyChallenges(userId: userId)
        } catch {
            print("Error deleting challenge: \(error)")
        }
    }
}
