//
//  ChallengeDifficulty.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

enum ChallengeDifficulty: String, Decodable, CaseIterable, Identifiable {
    case easy, medium, hard
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }

    var chalPoin: Int {
        switch self {
        case .easy: return 10
        case .medium: return 15
        case .hard: return 20
        }
    }
}
