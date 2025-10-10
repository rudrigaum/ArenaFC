//
//  TeamDetailsViewModelTests.swift
//  ArenaFCTests
//
//  Created by Rodrigo Cerqueira Reis on 10/10/25.
//

import Foundation
import XCTest
@testable import ArenaFC

@MainActor
final class TeamDetailsViewModelTests: XCTestCase {

    private var sut: TeamDetailsViewModel!
    private var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = TeamDetailsViewModel(teamId: 1, seasonYear: 2024, service: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetchAllDetails_whenBothFetchesSucceed_shouldUpdateAllProperties() async {
        let mockTeam = Team(id: 1, name: "Test Team", code: nil, country: nil, founded: nil, national: false, logo: URL(string: "a.com")!)
        let mockVenue = Venue(id: 1, name: "Test Stadium", address: nil, city: nil, capacity: nil, surface: nil, image: nil)
        mockAPIService.teamDetailsResult = .success(TeamDetailsWrapper(team: mockTeam, venue: mockVenue))
        
        let mockPlayer = Player(id: 1, name: "Test Player", firstname: nil, lastname: nil, age: nil, nationality: nil, height: nil, weight: nil, injured: false, photo: nil)
        mockAPIService.playersResult = .success([PlayerResponseWrapper(player: mockPlayer)])
        
        await sut.fetchDetails()
        
        XCTAssertFalse(sut.isLoading, "Main loading should be false")
        XCTAssertFalse(sut.isLoadingPlayers, "Players loading should be false")
        XCTAssertNotNil(sut.teamDetails, "Team details should be populated")
        XCTAssertEqual(sut.teamDetails?.team.name, "Test Team")
        XCTAssertEqual(sut.players.count, 1, "Players array should contain one player")
        XCTAssertEqual(sut.players.first?.name, "Test Player")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on success")
    }
    
        func test_fetchAllDetails_whenPlayerFetchFails_shouldPopulateTeamDetailsAndUpdateErrorMessage() async {
            let mockTeam = Team(id: 1, name: "Test Team", code: nil, country: nil, founded: nil, national: false, logo: URL(string: "a.com")!)
            let mockVenue = Venue(id: 1, name: "Test Stadium", address: nil, city: nil, capacity: nil, surface: nil, image: nil)
            mockAPIService.teamDetailsResult = .success(TeamDetailsWrapper(team: mockTeam, venue: mockVenue))
            
            let expectedError = NetworkError.serverError(statusCode: 500)
            mockAPIService.playersResult = .failure(expectedError)
            
            await sut.fetchDetails()
            
            XCTAssertNotNil(sut.teamDetails, "Team details should still be populated even if players fetch fails")
            XCTAssertEqual(sut.teamDetails?.team.name, "Test Team")
            
            XCTAssertTrue(sut.players.isEmpty, "Players array should be empty on failure")
            XCTAssertNotNil(sut.errorMessage, "Error message should not be nil when players fetch fails")
            XCTAssertEqual(sut.errorMessage, expectedError.description)
        }
}
