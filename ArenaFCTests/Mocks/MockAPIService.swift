//
//  MockAPIService.swift
//  ArenaFCTests
//
//  Created by Rodrigo Cerqueira Reis on 29/09/25.
//

import Foundation
@testable import ArenaFC

final class MockAPIService: APIServiceProtocol {
    
    var leaguesResult: Result<[LeagueWrapper], NetworkError>?
    var standingsResult: Result<[Standing], NetworkError>?
    
    func fetchLeagues() async throws -> [LeagueWrapper] {
        if let result = leaguesResult {
            switch result {
            case .success(let wrappers):
                return wrappers
            case .failure(let error):
                throw error
            }
        }
        fatalError("You must set a result for fetchLeagues before calling it.")
    }
    
    func fetchStandings(for leagueId: Int, season: Int) async throws -> [Standing] {
        if let result = standingsResult {
            switch result {
            case .success(let standings):
                return standings
            case .failure(let error):
                throw error
            }
        }
        fatalError("You must set a result for fetchStandings before calling it.")
    }
    
    func fetchTeamDetails(for teamId: Int) async throws -> TeamDetailsWrapper? { nil }
    func fetchPlayers(for teamId: Int, season: Int) async throws -> [PlayerResponseWrapper] { [] }
}
