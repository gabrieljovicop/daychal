//
//  CompleteChallngeParams.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct CompleteChallengeParams: Encodable {
    let history_id: UUID
    let user_id: UUID
    let point: Int
}
