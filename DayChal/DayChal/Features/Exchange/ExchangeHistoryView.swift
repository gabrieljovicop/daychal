//
//  ExchangeHistoryView.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import SwiftUI

struct ExchangeHistoryView: View {

    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = ExchangeHistoryViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Load history...")
            } else if vm.items.isEmpty {
                ContentUnavailableView("No exchange history yet", systemImage: "tray")
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(vm.items) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.gift.giftName).bold()
                                Text("\(item.gift.giftPrice) poin")
                                    .font(.caption)

                                if let date = item.exchangedAt {
                                    Text("Exchanged at \(date.formatted())")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 2)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Exchange History")
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear {
            if let profile = session.profile {
                Task { await vm.load(userId: profile.id) }
            }
        }
    }
}

enum ExchangeAlert: Identifiable {
    case notEnoughPoint

    var id: String { "exchange_alert" }

    var message: String {
        "Your ChalPoin are not enough to exchange this"
    }
}
