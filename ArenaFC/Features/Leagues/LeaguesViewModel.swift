//
//  LeaguesViewModel.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

@MainActor
final class LeaguesViewModel: ObservableObject {
    
    @Published var leagues: [League] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var leagueWrappers: [LeagueWrapper] = []
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    func fetchLeagues() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let fetchedWrappers = try await service.fetchLeagues()
            self.leagueWrappers = fetchedWrappers
            self.leagues = fetchedWrappers.map { $0.league }
            
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func navigationData(for league: League) -> LeagueNavigationData? {
        guard let wrapper = leagueWrappers.first(where: { $0.league.id == league.id }),
              !wrapper.seasons.isEmpty else {
            return nil
        }
        
        let sortedSeasons = wrapper.seasons.sorted { $0.year > $1.year }
        guard let latestSeason = sortedSeasons.first else { return nil }
        return LeagueNavigationData(league: league, currentSeasonYear: latestSeason.year, availableSeasons: sortedSeasons)
    }
    
}
