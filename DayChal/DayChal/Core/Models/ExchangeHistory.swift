//
//  ExchangeHistory.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct ExchangeHistory: Identifiable, Decodable {
    let id: UUID
    let userId: UUID
    let giftId: UUID
    let exchangedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case giftId = "gift_id"
        case exchangedAt = "exchanged_at"
    }
}
