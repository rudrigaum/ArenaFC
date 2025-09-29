//
//  Leagues.swift
//  ArenaFCTests
//
//  Created by Rodrigo Cerqueira Reis on 29/09/25.
//

import Foundation
import XCTest
@testable import ArenaFC

@MainActor
final class LeaguesViewModelTests: XCTestCase {

    private var sut: LeaguesViewModel!
    private var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = LeaguesViewModel(service: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetchLeagues_whenAPIReturnsSuccess_shouldUpdateLeaguesProperty() async {
        let mockData = [
            LeagueWrapper(league: League(id: 1, name: "Premier League", type: "League", logo: URL(string: "a.com")!),
                          country: Country(name: "England", code: "GB", flag: nil),
                          seasons: [])
        ]
        mockAPIService.leaguesResult = .success(mockData)
        
        await sut.fetchLeagues()

        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch completes")
        XCTAssertEqual(sut.leagues.count, 1, "There should be 1 league in the array")
        XCTAssertEqual(sut.leagues.first?.name, "Premier League", "The league name should match the mock data")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on a successful fetch")
    }
    
    func test_fetchLeagues_whenAPIReturnsFailure_shouldUpdateErrorMessage() async {
        let expectedError = NetworkError.serverError(statusCode: 500)
        mockAPIService.leaguesResult = .failure(expectedError)
        
        await sut.fetchLeagues()
        
        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch completes")
        XCTAssertTrue(sut.leagues.isEmpty, "Leagues array should remain empty on failure")
        XCTAssertNotNil(sut.errorMessage, "Error message should not be nil on failure")
        XCTAssertEqual(sut.errorMessage, expectedError.description, "Error message should match the simulated error description")
    }
}
