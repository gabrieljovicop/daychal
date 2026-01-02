//
//  Profile.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation


//Sebelumnya Decodable, Identifiable
struct Profile: Identifiable, Codable, Equatable {
    let id: UUID
    let username: String
    let email: String
    let myChalPoin: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case myChalPoin = "my_chal_poin"
        case createdAt = "created_at"
    }
}
