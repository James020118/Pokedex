//
//  FetchListResponse.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import Foundation

struct FetchListResponse: Codable {
    let count: Int
    var next: String
    var previous: String
    var results: [Pokemon]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.next = try container.decodeIfPresent(String.self, forKey: .next) ?? ""
        self.previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? ""
        self.results = try container.decodeIfPresent([Pokemon].self, forKey: .results) ?? []
    }
}
