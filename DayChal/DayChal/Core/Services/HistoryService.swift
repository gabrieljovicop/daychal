//
//  HistoryService.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation
import Supabase

protocol HistoryServiceProtocol {
    func fetchHistory(userId: UUID) async throws -> [HistoryItem]
}

final class HistoryService: HistoryServiceProtocol {

    private let client = SupabaseManager.shared.client

    func fetchHistory(userId: UUID) async throws -> [HistoryItem] {

        let response: [ChallengeHistoryJoin] = try await client
             .from("challenge_histories")
             .select("""
                 id,
                 status,
                 accepted_at,
                 completed_at,
                 challenges (*)
             """)
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
        
        return response.map { item in
            HistoryItem(
                id: item.id,
                challenge: item.challenge,
                status: item.status,
                acceptedAt: item.acceptedAt,
                completedAt: item.completedAt
            )
        }
    }
}
