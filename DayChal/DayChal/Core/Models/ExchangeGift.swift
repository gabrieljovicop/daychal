//
//  ExchangeGift.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct ExchangeGift: Identifiable, Decodable {
    let id: UUID
    let giftName: String
    let giftPrice: Int

    enum CodingKeys: String, CodingKey {
        case id
        case giftName = "gift_name"
        case giftPrice = "gift_price"
    }
}
