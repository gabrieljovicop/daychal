//
//  ChallengeCategory.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

enum ChallengeCategory: String, Decodable, CaseIterable, Identifiable {
    case all, sport, game, study, art, social
    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}
