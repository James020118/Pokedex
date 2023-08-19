//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-19.
//

import Foundation

struct PokemonDetail: Codable, Identifiable {
    let id = UUID().uuidString
    let name: String
    let images: PokemonImages
    
    init(name: String) {
        self.name = name
        images = PokemonImages(front_image: "")
    }
    
    private enum CodingKeys : String, CodingKey {
        case name
        case images = "sprites"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.images = try container.decode(PokemonImages.self, forKey: .images)
    }
}
