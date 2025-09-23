//
//  TeamDetailsViewModel.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 23/09/25.
//

import Foundation

@MainActor
final class TeamDetailsViewModel: ObservableObject {

    @Published var teamDetails: TeamDetailsWrapper?
    @Published var players: [Player] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingPlayers: Bool = false
    @Published var errorMessage: String?
    
    private let teamId: Int
    private let seasonYear: Int
    private let service: APIServiceProtocol
    
    init(teamId: Int, seasonYear: Int, service: APIServiceProtocol = APIService()) {
        self.teamId = teamId
        self.seasonYear = seasonYear
        self.service = service
    }
    
    func fetchDetails() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let details = try await service.fetchTeamDetails(for: teamId)
            
            if let details = details {
                self.teamDetails = details
                await fetchPlayers()
            } else {
                self.errorMessage = "Team details not found."
            }
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func fetchPlayers() async {
        isLoadingPlayers = true
        defer { isLoadingPlayers = false }
        
        do {
            let playerWrappers = try await service.fetchPlayers(for: teamId, season: seasonYear)
            self.players = playerWrappers.map { $0.player }
        } catch let error as NetworkError {
            print("Could not load players: \(error.description)")
            self.errorMessage = error.description
        } catch {
            print("Could not load players: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
}
