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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    private let teamId: Int
    private let service: APIServiceProtocol
    
    init(teamId: Int, service: APIServiceProtocol = APIService()) {
        self.teamId = teamId
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
            } else {
                self.errorMessage = "Team details not found."
            }
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
