//
//  NetworkError.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed(Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let error):
            return "The request failed. Original error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid (not a valid HTTP response)."
        case .serverError(let statusCode):
            return "The server returned an error with status code: \(statusCode)."
        case .decodingFailed(let error):
            return "Failed to decode the JSON response. Original error: \(error)"
        }
    }
}
