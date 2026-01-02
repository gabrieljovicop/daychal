//
//  Challenge.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

struct Challenge: Identifiable, Decodable {

    let id: UUID
    let creatorId: UUID?
    let challengeName: String
    let challengeDescription: String
    let challengeCategory: ChallengeCategory
    let challengeDifficulty: ChallengeDifficulty
    let chalPoin: Int
    let createdAt: Date
    
    let creatorProfile: CreatorProfile?

    enum CodingKeys: String, CodingKey {
        case id
        case creatorId = "creator_id"
        case challengeName = "challenge_name"
        case challengeDescription = "challenge_description"
        case challengeCategory = "challenge_category"
        case challengeDifficulty = "challenge_difficulty"
        case chalPoin = "chal_poin"
        case createdAt = "created_at"
        
        case creatorProfile = "profiles"
    }
}

struct CreatorProfile: Decodable {
    let username: String
}
