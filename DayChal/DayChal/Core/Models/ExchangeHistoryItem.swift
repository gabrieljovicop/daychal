//
//  ExchangeHistoryItem.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct ExchangeHistoryItem: Identifiable, Decodable {
    let id: UUID
    let exchangedAt: Date?
    let gift: ExchangeGift

    enum CodingKeys: String, CodingKey {
        case id
        case exchangedAt = "exchanged_at"
        case gift
    }
}
