//
//  LeaguesView.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation
import SwiftUI

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
                        NavigationLink(value: league) {
                            HStack(spacing: 16) {
                                AsyncImage(url: league.logo) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                
                                Text(league.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Leagues") //
            .navigationDestination(for: League.self) { league in
                Text("Standings for \(league.name)")
                    .navigationTitle(league.name)
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
