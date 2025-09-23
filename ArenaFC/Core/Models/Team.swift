//
//  Team.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

struct APIResponseTeams: Decodable {
    let response: [TeamDetailsWrapper]
}

struct TeamDetailsWrapper: Decodable {
    let team: Team
    let venue: Venue?
}

struct Team: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let code: String?
    let country: String?
    let founded: Int?
    let national: Bool?
    let logo: URL
}
