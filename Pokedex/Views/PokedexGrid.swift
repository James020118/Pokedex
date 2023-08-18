//
//  PokedexGrid.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-17.
//

import SwiftUI

struct PokedexGrid: View {
    
    init(viewModel: PokedexGridViewModel) {
        self.viewModel = viewModel
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: .medium),
        GridItem(.flexible(), spacing: .medium),
        GridItem(.flexible(), spacing: .medium),
    ]
    
    @ObservedObject private var viewModel: PokedexGridViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: .medium) {
                    ForEach(viewModel.pokemons) { pokemon in
                        PokedexGridCell(pokemon: pokemon)
                    }
                }
            }
            .navigationTitle("Pokédex")
            .padding(.horizontal, .screenEdge)
        }
        .onAppear {
            viewModel.getPokemonList()
        }
    }
}

struct PokedexGrid_Previews: PreviewProvider {
    static var previews: some View {
        PokedexGrid(
            viewModel: PokedexGridViewModel(networkService: NetworkServiceImpl())
        )
    }
}
