//
//  HistoryItem.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

struct HistoryItem: Identifiable {
    let id: UUID
    let challenge: Challenge
    let status: HistoryStatus
    let acceptedAt: Date?
    let completedAt: Date?
}


