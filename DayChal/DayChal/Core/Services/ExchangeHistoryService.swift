//
//  ExchangeHistoryService.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation
import Supabase

protocol ExchangeHistoryServiceProtocol {
    func fetchHistory(userId: UUID) async throws -> [ExchangeHistoryItem]
}

final class ExchangeHistoryService: ExchangeHistoryServiceProtocol {

    private let client = SupabaseManager.shared.client

    func fetchHistory(userId: UUID) async throws -> [ExchangeHistoryItem] {
        try await client
            .from("exchange_histories")
            .select("""
                id,
                exchanged_at,
                gift:exchange_gifts (
                    id,
                    gift_name,
                    gift_price
                )
            """)
            .eq("user_id", value: userId.uuidString)
            .order("exchanged_at", ascending: false)
            .execute()
            .value
    }
}
