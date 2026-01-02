//
//  ChallengeRow.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct ChallengeRow: View {
    let challenge: Challenge
    let source: ChallengeSource
    let dateInfo: Date?
    let historyId: UUID?
    
    init(
        challenge: Challenge,
        source: ChallengeSource,
        dateInfo: Date? = nil,
        historyId: UUID? = nil
    ) {
        self.challenge = challenge
        self.source = source
        self.dateInfo = dateInfo
        self.historyId = historyId
    }
    
    var body: some View {
        NavigationLink(destination: ChallengeDetailView(challenge: challenge, source: source, historyId: historyId)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(challenge.challengeCategory.title)
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text(challenge.challengeDifficulty.rawValue.capitalized)
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(challenge.challengeDifficulty.color.opacity(0.1))
                        .foregroundColor(challenge.challengeDifficulty.color)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text("\(challenge.chalPoin) Poin")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                }
                
                Text(challenge.challengeName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                if let username = challenge.creatorProfile?.username {
                    Text("by \(username)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Group {
                    switch source {
                    case .home:
                        Text("Level: \(challenge.challengeDifficulty.rawValue.capitalized)")
                            .foregroundColor(challenge.challengeDifficulty.color)
                    case .historyOnGoing:
                        if let date = dateInfo {
                            Text("Accepted: \(date.formatted(date: .abbreviated, time: .omitted))")
                        }
                    case .historyCompleted:
                        if let date = dateInfo {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Completed: \(date.formatted(date: .abbreviated, time: .omitted))")
                            }
                            .foregroundColor(.green)
                        }
                    case .myChallenge:
                        Text("Created at: \(challenge.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
        .buttonStyle(.plain)
    }
}

enum ChallengeSource {
    case home
    case myChallenge
    case historyOnGoing
    case historyCompleted
}
