//
//  ExchangeView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct ExchangeView: View {

    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = ExchangeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                pointSummaryCard
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Rewards")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if vm.gifts.isEmpty {
                        ContentUnavailableView("No gifts available", systemImage: "gift.slash")
                    } else {
                        ForEach(vm.gifts) { gift in
                            ExchangeRow(
                                gift: gift,
                                isDisabled: (session.profile?.myChalPoin ?? 0) < gift.giftPrice
                            ) {
                                handleExchange(gift: gift)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Exchange")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ExchangeHistoryView()
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
        .alert(item: $vm.alert) { alertType in
            Alert(
                title: Text("Opps!"),
                message: Text(alertType.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert("Success!", isPresented: $vm.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your gift has been successfully redeemed.")
        }
        .onAppear {
            Task { await vm.loadGifts() }
        }
    }
}

private extension ExchangeView {
    var pointSummaryCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Balance")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 8) {
                    Image(systemName: "star.circle.fill")
                        .font(.title2)
                    Text("\(session.profile?.myChalPoin ?? 0)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text("Points")
                        .font(.headline)
                }
                .foregroundColor(.white)
            }
            Spacer()
            
            Image(systemName: "giftcard.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(24)
        .background(
            LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    func handleExchange(gift: ExchangeGift) {
        guard let profile = session.profile else { return }
        
        guard profile.myChalPoin >= gift.giftPrice else {
            vm.alert = .notEnoughPoint
            return
        }

        Task {
            await vm.exchange(
                gift: gift,
                userId: profile.id
            )
            await session.refreshProfile()
        }
    }
}
