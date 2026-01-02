//
//  Formatters.swift
//  DayChal
//
//  Created by prk on 15/12/25.
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
