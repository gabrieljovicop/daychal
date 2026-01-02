//
//  CategoryChip.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import SwiftUI

struct CategoryChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}
