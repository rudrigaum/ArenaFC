//
//  APIServiceProtocol.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

protocol APIServiceProtocol {

    func fetchLeagues() async throws -> [LeagueWrapper]

}
