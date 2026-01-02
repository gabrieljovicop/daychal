//
//  ChallengeHistoryJoin.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct ChallengeHistoryJoin: Decodable {
    let id: UUID
    let status: HistoryStatus
    let acceptedAt: Date?
    let completedAt: Date?
    let challenge: Challenge

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case acceptedAt = "accepted_at"
        case completedAt = "completed_at"
        case challenge = "challenges"
    }
}
