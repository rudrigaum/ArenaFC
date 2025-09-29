//
//  TeamDetailsView.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 23/09/25.
//

import Foundation
import SwiftUI

struct TeamDetailsView: View {
    @StateObject private var viewModel: TeamDetailsViewModel
    
    init(teamId: Int, seasonYear: Int) {
        _viewModel = StateObject(wrappedValue: TeamDetailsViewModel(teamId: teamId, seasonYear: seasonYear))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Team Details...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let details = viewModel.teamDetails {
                contentView(for: details)
            }
        }
        .task {
            await viewModel.fetchDetails()
        }
    }
    
    private func contentView(for details: TeamDetailsWrapper) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView(for: details.team)
                
                if let venue = details.venue {
                    venueView(for: venue)
                }
                
                playerRosterView()
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func headerView(for team: Team) -> some View {
        VStack {
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            Text(team.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Founded in \(team.founded ?? 0, specifier: "%d") - \(team.country ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func venueView(for venue: Venue) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(venue.name ?? "No Venue Name")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(venue.city ?? "No city")
                    .font(.headline)
                
                if let capacity = venue.capacity {
                    Text("Capacity: \(capacity, specifier: "%d")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        } header: {
            Text("Stadium Information")
                .font(.headline)
        }
    }
    
    private func playerRosterView() -> some View {
        Section {
            if viewModel.isLoadingPlayers {
                ProgressView()
            } else if viewModel.players.isEmpty {
                Text("Player roster not available for this season.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.players) { player in
                        PlayerRowView(player: player)
                        Divider()
                    }
                }
            }
        } header: {
            Text("Player Roster")
                .font(.title2.bold())
                .padding(.bottom, 8)
        }
    }
}

private struct PlayerRowView: View {
    let player: Player
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: player.photo) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.secondary.opacity(0.4))
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(player.name ?? "Unknown Player")
                    .font(.headline)
                
                let ageString = player.age.map { "Age: \($0)" } ?? "N/A"
                let nationalityString = player.nationality ?? "Unknown"
                Text("\(ageString) - \(nationalityString)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
