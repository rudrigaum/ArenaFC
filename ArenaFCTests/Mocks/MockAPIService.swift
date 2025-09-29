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

    func fetchStandings(for leagueId: Int, season: Int) async throws -> [Standing] { [] }
    func fetchTeamDetails(for teamId: Int) async throws -> TeamDetailsWrapper? { nil }
    func fetchPlayers(for teamId: Int, season: Int) async throws -> [PlayerResponseWrapper] { [] }
}
