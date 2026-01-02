//
//  ChallengeService.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation
import Supabase

protocol ChallengeServiceProtocol {
    func fetchChallenges(category: ChallengeCategory) async throws -> [Challenge]
//    func acceptChallenge(
//        challengeId: UUID,
//        userId: UUID
//    ) async throws
}

final class ChallengeService: ChallengeServiceProtocol {

    private let client = SupabaseManager.shared.client

    func fetchChallenges(category: ChallengeCategory) async throws -> [Challenge] {

        var query = client
            .from("challenges")
            .select()

        if category != .all {
            query = query.eq("challenge_category", value: category.rawValue)
        }

        return try await query
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
//    func acceptChallenge(
//        challengeId: UUID,
//        userId: UUID
//    ) async throws {
//        
//        // check existing
//        let existing: [ChallengeHistory] = try await client
//            .from("challenge_histories")
//            .select("id")
//            .eq("user_id", value: userId.uuidString)
//            .eq("challenge_id", value: challengeId.uuidString)
//            .execute()
//            .value
//
//        guard existing.isEmpty else {
//            throw NSError(domain: "Challenge", code: 409)
//        }
//
//        try await client
//            .from("challenge_histories")
//            .insert([
//                "user_id": userId.uuidString,
//                "challenge_id": challengeId.uuidString,
//                "status": HistoryStatus.onGoing.rawValue,
//                "accepted_at": ISO8601DateFormatter().string(from: Date())
//            ])
//            .execute()
//    }
}
