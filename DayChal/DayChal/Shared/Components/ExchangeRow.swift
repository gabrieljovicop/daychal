//
//  ExchangeRow.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import SwiftUI

//struct ExchangeRow: View {
//
//    let gift: ExchangeGift
//    let onExchange: () -> Void
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(gift.giftName).bold()
//                Text("\(gift.giftPrice) poin")
//                    .font(.caption)
//            }
//            Spacer()
//            Button("Exchange") {
//                onExchange()
//            }
//        }
//        .padding()
//        .background(.white)
//        .cornerRadius(12)
//    }
//}

struct ExchangeRow: View {
    let gift: ExchangeGift
    let isDisabled: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(gift.giftName)
                    .font(.headline)
                Text("\(gift.giftPrice) Poin")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .bold()
            }
            
            Spacer()
            
            Button(action: onTap) {
                Text("Redeem")
                    .font(.footnote.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isDisabled)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
