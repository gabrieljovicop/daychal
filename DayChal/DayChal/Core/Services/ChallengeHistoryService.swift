//
//  ChallengeHistoryService.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation
import Supabase

protocol ChallengeHistoryServiceProtocol {
    func acceptChallenge(userId: UUID, challengeId: UUID) async throws
    func completeChallenge(historyId: UUID, userId: UUID, earnPoint: Int) async throws
}

final class ChallengeHistoryService: ChallengeHistoryServiceProtocol {

    private let client = SupabaseManager.shared.client

    func acceptChallenge(userId: UUID, challengeId: UUID) async throws {

        try await client
            .from("challenge_histories")
            .insert([
                "user_id": userId.uuidString,
                "challenge_id": challengeId.uuidString,
                "status": HistoryStatus.onGoing.rawValue,
                "accepted_at": ISO8601DateFormatter().string(from: Date())
            ])
            .execute()
    }
    
    func completeChallenge(historyId: UUID, userId: UUID, earnPoint: Int) async throws {
        try await client
            .from("challenge_histories")
            .update([
                "status": HistoryStatus.completed.rawValue,
                "completed_at": ISO8601DateFormatter().string(from: Date())
            ])
            .eq("id", value: historyId.uuidString)
            .execute()
        
        try await client
            .rpc(
                "increment_chal_poin",
                params: IncrementChalPoinParams(
                    user_id: userId,
                    point: earnPoint
                )
            )
            .execute()
    }
}
