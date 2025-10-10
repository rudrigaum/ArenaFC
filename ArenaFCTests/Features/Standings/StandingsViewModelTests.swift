//
//  StandingsViewModelTests.swift
//  ArenaFCTests
//
//  Created by Rodrigo Cerqueira Reis on 10/10/25.
//

import Foundation
import XCTest
@testable import ArenaFC

@MainActor
final class StandingsViewModelTests: XCTestCase {

    private var sut: StandingsViewModel!
    private var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        
        let mockLeague = League(id: 39, name: "Premier League", type: "League", logo: URL(string: "a.com")!)
        let mockSeason = Season(year: 2024, startDate: "2024-08-01", endDate: "2025-05-31", current: true)
        let mockNavigationData = LeagueNavigationData(league: mockLeague,
                                                    currentSeasonYear: 2024,
                                                    availableSeasons: [mockSeason])
        
        sut = StandingsViewModel(data: mockNavigationData, service: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetchStandings_whenSuccessful_shouldUpdateStandingsProperty() async {
        let mockTeam = Team(id: 1, name: "Test FC", code: "TFC", country: "Testland", founded: 2025, national: false, logo: URL(string: "b.com")!)
        let mockStandings = [
            Standing(rank: 1, team: mockTeam, points: 90, goalsDiff: 50, group: "Group A", form: "W", status: "ok", description: nil, all: .init(played: 38, win: 30, draw: 0, lose: 8))
        ]
        mockAPIService.standingsResult = .success(mockStandings)
    
        await sut.fetchStandings()
        
        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch")
        XCTAssertEqual(sut.standings.count, 1, "Standings array should contain one team")
        XCTAssertEqual(sut.standings.first?.team.name, "Test FC")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on success")
    }
}
