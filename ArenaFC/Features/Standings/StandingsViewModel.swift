//
//  StandingsViewModel.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 18/09/25.
//

import Foundation

@MainActor
final class StandingsViewModel: ObservableObject {

    @Published var standings: [Standing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let league: League
    private let service: APIServiceProtocol

    init(league: League, service: APIServiceProtocol = APIService()) {
        self.league = league
        self.service = service
    }

    func fetchStandings() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }

        do {
            let seasonYear = 2024
            let fetchedStandings = try await service.fetchStandings(for: league.id, season: seasonYear)
            self.standings = fetchedStandings
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
