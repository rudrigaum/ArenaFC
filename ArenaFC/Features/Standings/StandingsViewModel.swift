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
    @Published var selectedSeasonYear: Int

    let league: League
    let availableSeasons: [Season]
    private let service: APIServiceProtocol

    init(data: LeagueNavigationData, service: APIServiceProtocol = APIService()) {
        self.league = data.league
        self.availableSeasons = data.availableSeasons
        self.selectedSeasonYear = data.currentSeasonYear
        self.service = service
    }

    func fetchStandings() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }

        do {
            let fetchedStandings = try await service.fetchStandings(for: league.id, season: selectedSeasonYear)
            self.standings = fetchedStandings
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
