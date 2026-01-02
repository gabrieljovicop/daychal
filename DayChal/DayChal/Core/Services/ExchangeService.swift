//
//  ExchangeService.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation
import Supabase

protocol ExchangeServiceProtocol {
    func fetchGifts() async throws -> [ExchangeGift]
    func exchangeGift(
        giftId: UUID,
        userId: UUID,
        price: Int
    ) async throws
}

final class ExchangeService: ExchangeServiceProtocol {

    private let client = SupabaseManager.shared.client

    func fetchGifts() async throws -> [ExchangeGift] {
        try await client
            .from("exchange_gifts")
            .select()
            .order("gift_price", ascending: true)
            .execute()
            .value
    }

    func exchangeGift(
        giftId: UUID,
        userId: UUID,
        price: Int
    ) async throws {

        try await client
            .from("exchange_histories")
            .insert([
                "user_id": userId.uuidString,
                "gift_id": giftId.uuidString
            ])
            .execute()

        try await client.rpc(
            "increment_chal_poin",
            params: IncrementChalPoinParams(
                user_id : userId,
                point: -price
            )
        )
        .execute()
    }
}

