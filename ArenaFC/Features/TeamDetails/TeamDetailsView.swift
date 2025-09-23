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
    
    init(teamId: Int) {
        _viewModel = StateObject(wrappedValue: TeamDetailsViewModel(teamId: teamId))
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
        .navigationTitle(viewModel.teamDetails?.team.name ?? "Details")
    }
    
    private func contentView(for details: TeamDetailsWrapper) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView(for: details.team)
                
                if let venue = details.venue {
                    venueView(for: venue)
                }
                
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
}
