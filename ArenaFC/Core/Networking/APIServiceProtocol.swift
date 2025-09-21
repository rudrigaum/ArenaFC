//
//  APIServiceProtocol.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchLeagues() async throws -> [LeagueWrapper]
    func fetchStandings(for leagueId: Int, season: Int) async throws -> [Standing]
}
