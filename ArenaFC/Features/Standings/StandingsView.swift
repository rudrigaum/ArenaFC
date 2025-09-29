//
//  StandingsView.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 21/09/25.
//

import Foundation
import SwiftUI

struct StandingsView: View {
    @StateObject private var viewModel: StandingsViewModel

    init(data: LeagueNavigationData) {
        _viewModel = StateObject(wrappedValue: StandingsViewModel(data: data))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Standings...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                mainContentView
            }
        }
        .navigationTitle(viewModel.league.name)
        .task {
            await viewModel.fetchStandings()
        }
    }
    
    private var mainContentView: some View {
        List {
            Section {
                Picker("Season", selection: $viewModel.selectedSeasonYear) {
                    ForEach(viewModel.availableSeasons) { season in
                        Text(season.seasonDisplay).tag(season.year)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section {
                StandingsHeaderView()
                
                ForEach(viewModel.standings) { standing in
                    NavigationLink(value: standing.team) {
                        StandingsRowView(standing: standing)
                    }
                }
            }
        }
        .navigationDestination(for: Team.self) { team in
            TeamDetailsView(teamId: team.id, seasonYear: viewModel.selectedSeasonYear)
        }
        .onChange(of: viewModel.selectedSeasonYear) {
            Task {
                await viewModel.fetchStandings()
            }
        }
    }
}

private struct StandingsRowView: View {
    let standing: Standing
    
    var body: some View {
        HStack {
            Text("\(standing.rank)")
                .frame(width: 30, alignment: .leading)
            
            AsyncImage(url: standing.team.logo) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 25, height: 25)
            
            Text(standing.team.name)
            
            Spacer()
            
            Text("\(standing.all.played)").frame(width: 30)
            Text("\(standing.points)").frame(width: 40)
        }
        .font(.system(size: 14))
    }
}

private struct StandingsHeaderView: View {
    var body: some View {
        HStack {
            Text("Pos")
                .frame(width: 30, alignment: .leading)
            
            Spacer().frame(width: 25)
            
            Text("Club")
            
            Spacer()
            
            Text("P").frame(width: 30)
            Text("Pts").frame(width: 40)
        }
        .font(.system(size: 12).bold())
        .foregroundColor(.secondary)
    }
}
