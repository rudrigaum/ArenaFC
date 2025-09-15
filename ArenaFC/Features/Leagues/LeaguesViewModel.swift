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
            let leagueWrappers = try await service.fetchLeagues()
            self.leagues = leagueWrappers.map { $0.league }
        } catch let error as NetworkError {
            self.errorMessage = error.description
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
