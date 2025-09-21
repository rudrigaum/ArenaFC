//
//  LeaguesView.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation
import SwiftUI

struct LeagueNavigationData: Hashable {
    let league: League
    let seasonYear: Int
}

struct LeaguesView: View {
    @StateObject private var viewModel = LeaguesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Leagues...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.leagues) { league in
                        let cellView = HStack(spacing: 16) {
                            AsyncImage(url: league.logo) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            
                            Text(league.name)
                                .font(.headline)
                        }
                        if let seasonYear = viewModel.findCurrentSeasonYear(for: league) {
                            let navigationData = LeagueNavigationData(league: league, seasonYear: seasonYear)
                            NavigationLink(value: navigationData) {
                                cellView
                            }
                        } else {
                            cellView
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Leagues")
            .navigationDestination(for: LeagueNavigationData.self) { data in
                Text("Standings for \(data.league.name) - Season \(data.seasonYear)")
                    .navigationTitle(data.league.name)
            }
            .task {
                await viewModel.fetchLeagues()
            }
        }
    }
}

#Preview {
    LeaguesView()
}
