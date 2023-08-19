//
//  PokemonImages.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-19.
//

import Foundation

struct PokemonImages: Codable {
    let front_image: String
    
    private enum CodingKeys : String, CodingKey {
        case front_image = "front_default"
    }
}
