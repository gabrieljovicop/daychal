//
//  ChallengeInsertRequest.swift
//  DayChal
//
//  Created by prk on 18/12/25.
//

import Foundation

struct ChallengeInsertRequest: Encodable {
    let creator_id: UUID
    let challenge_name: String
    let challenge_description: String
    let challenge_category: String
    let challenge_difficulty: String
    let chal_poin: Int
}
