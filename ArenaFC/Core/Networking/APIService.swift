//
//  APIService.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

final class APIService: APIServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchLeagues() async throws -> [LeagueWrapper] {
        let apiResponse: APIResponseLeagues = try await request(path: "/leagues")
        return apiResponse.response
    }
    
    func fetchStandings(for leagueId: Int, season: Int) async throws -> [Standing] {
        let queryItems = [
            URLQueryItem(name: "league", value: String(leagueId)),
            URLQueryItem(name: "season", value: String(season))
        ]
        let apiResponse: APIResponseStandings = try await request(path: "/standings", queryItems: queryItems)
        
        let standings = apiResponse.response.first?.league.standings.first
        return standings ?? []
    }
    
    private func request<T: Decodable>(path: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "v3.football.api-sports.io"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String, !apiKey.isEmpty else {
            throw NetworkError.apiKeyNotFound
        }
        
        request.addValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ DECODING ERROR for type \(T.self): \(error)")
            if let decodingError = error as? DecodingError {
                print("Decoding Error Details: \(decodingError)")
            }
            throw NetworkError.decodingFailed(error)
        }
    }
}
