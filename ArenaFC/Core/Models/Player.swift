//
//  Player.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 23/09/25.
//

import Foundation

struct APIResponsePlayers: Decodable {
    let response: [PlayerResponseWrapper]
}

struct PlayerResponseWrapper: Decodable {
    let player: Player
}

struct Player: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String?
    let firstname: String?
    let lastname: String?
    let age: Int?
    let nationality: String?
    let height: String?
    let weight: String?
    let injured: Bool?
    let photo: URL?
}
