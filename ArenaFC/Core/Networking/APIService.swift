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
        var components = URLComponents()
        components.scheme = "https"
        components.host = "v3.football.api-sports.io"
        components.path = "/leagues"

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        let apiKey = APIConstants.apiKey 
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
            let apiResponse = try decoder.decode(APIResponseLeagues.self, from: data)
            return apiResponse.response
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
