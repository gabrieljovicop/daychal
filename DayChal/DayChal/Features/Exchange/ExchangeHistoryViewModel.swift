//
//  ExchangeHistoryViewModel.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

@MainActor
final class ExchangeHistoryViewModel: ObservableObject {

    @Published var items: [ExchangeHistoryItem] = []
    @Published var isLoading = false

    private let service: ExchangeHistoryServiceProtocol

    init(service: ExchangeHistoryServiceProtocol = ExchangeHistoryService()) {
        self.service = service
    }

    func load(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await service.fetchHistory(userId: userId)
        } catch {
            print("Fetch exchange history error:", error)
        }
    }
}
