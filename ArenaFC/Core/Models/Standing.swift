//
//  Standing.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

struct APIResponseStandings: Decodable {
    let response: [StandingLeagueWrapper]
}

struct StandingLeagueWrapper: Decodable {
    let league: StandingData
}

struct StandingData: Decodable {
    let id: Int
    let name: String
    let country: String
    let logo: URL
    let flag: URL?
    let season: Int
    let standings: [[Standing]]
}

struct Standing: Decodable, Identifiable {
    let rank: Int
    let team: Team
    let points: Int
    let goalsDiff: Int
    let group: String
    let form: String?
    let status: String?
    let description: String?
    let all: TeamStats
    
    var id: Int { team.id }
}

struct TeamStats: Decodable {
    let played: Int
    let win: Int
    let draw: Int
    let lose: Int
}
