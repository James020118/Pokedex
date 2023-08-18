//
//  PokedexGridCell.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import SwiftUI

struct PokedexGridCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.teal.opacity(0.2))
                .frame(height: 150)
            
            content
        }
    }
}

private extension PokedexGridCell {
    var content: some View {
        VStack(spacing: .small) {
            Text(pokemon.name.capitalized)
            Image(systemName: "atom")
        }
    }
}

struct PokedexGridCell_Previews: PreviewProvider {
    static var previews: some View {
        PokedexGridCell(pokemon: Pokemon(name: "Pikachu", url: ""))
    }
}
