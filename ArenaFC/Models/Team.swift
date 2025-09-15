//
//  Team.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 15/09/25.
//

import Foundation

struct Team: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let logo: URL
}
