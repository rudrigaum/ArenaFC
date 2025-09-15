//
//  League.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

struct APIResponseLeagues: Decodable {
    let response: [LeagueWrapper]
}

struct LeagueWrapper: Decodable {
    let league: League
    let country: Country
    let seasons: [Season]
}

struct League: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let type: String?
    let logo: URL
}

struct Country: Decodable, Equatable {
    let name: String
    let code: String?
    let flag: URL?
}

struct Season: Decodable, Equatable {
    let year: Int
    let startDate: String
    let endDate: String
    let current: Bool

    enum CodingKeys: String, CodingKey {
        case year
        case startDate = "start"
        case endDate = "end"
        case current
    }
}
