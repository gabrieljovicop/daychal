//
//  ExchangeViewModel.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation

@MainActor
final class ExchangeViewModel: ObservableObject {

    @Published var gifts: [ExchangeGift] = []
    @Published var alert: ExchangeAlert?
    @Published var showSuccessAlert = false

    private let service: ExchangeServiceProtocol

    init(service: ExchangeServiceProtocol = ExchangeService()) {
        self.service = service
    }

    func loadGifts() async {
        do {
            gifts = try await service.fetchGifts()
        } catch {
            print("Fetch gifts error:", error)
        }
    }

    func exchange(
        gift: ExchangeGift,
        userId: UUID
    ) async {
        do {
            try await service.exchangeGift(
                giftId: gift.id,
                userId: userId,
                price: gift.giftPrice
            )
            self.showSuccessAlert = true
        } catch {
            self.alert = .notEnoughPoint
            print("Exchange error:", error)
        }
    }
}
