//
//  Venue.swift
//  ArenaFC
//
//  Created by Rodrigo Cerqueira Reis on 23/09/25.
//

import Foundation

struct Venue: Decodable, Hashable {
    let id: Int?
    let name: String?
    let address: String?
    let city: String?
    let capacity: Int?
    let surface: String?
    let image: URL?
}
