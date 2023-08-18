//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    var id: String
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.id = UUID().uuidString
        self.name = name
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
