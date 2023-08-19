//
//  PokedexGridCell.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import SwiftUI

struct PokedexGridCell: View {

    let detail: PokemonDetail
    
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
            Text(detail.name.capitalized)
                .bold()
            AsyncImage(
                url: URL(string: detail.images.front_image)
            ) { image in
                image
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct PokedexGridCell_Previews: PreviewProvider {
    static var previews: some View {
        PokedexGridCell(detail: PokemonDetail(name: "Pikachu"))
    }
}
