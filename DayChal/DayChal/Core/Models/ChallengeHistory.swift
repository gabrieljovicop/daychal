//
//  ChallengeHistory.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct ChallengeHistory: Identifiable, Decodable {

    let id: UUID
    let userId: UUID
    let challengeId: UUID
    let status: HistoryStatus
    let acceptedAt: Date?
    let completedAt: Date?
    let challenge: Challenge

    enum CodingKeys: String, CodingKey {
        case id, status, challenge = "challenges"
        case userId = "user_id"
        case challengeId = "challenge_id"
        case acceptedAt = "accepted_at"
        case completedAt = "completed_at"
    }
}

enum HistoryStatus: String, Decodable, Hashable, CaseIterable, Identifiable {
    case onGoing = "on_going"
    case completed = "completed"
    
    var id: String { rawValue }
}
