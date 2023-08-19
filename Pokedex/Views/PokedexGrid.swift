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
            GeometryReader { geometry in
                VStack {
                    displayCard(screenWidth: geometry.size.width)

                    ScrollView {
                        mainGrid
                    }
                    .navigationTitle("Pokédex")
                    .padding(.horizontal, .screenEdge)
                }
            }
        }
        .onAppear {
            viewModel.getPokemonList()
        }
    }
}

private extension PokedexGrid {
    var mainGrid: some View {
        LazyVGrid(columns: columns, spacing: .medium) {
            ForEach(viewModel.pokemonDetails) { detail in
                PokedexGridCell(detail: detail)
                    .onTapGesture {
                        viewModel.didTapCell(url: detail.images.front_image)
                    }
                    .onAppear {
                        guard !viewModel.isLoading else { return }
                        if viewModel.isLastPokemon(detail: detail) {
                            viewModel.getPokemonList()
                        }
                    }
            }
        }
    }
    
    func displayCard(screenWidth: CGFloat) -> some View {
        ZStack {
            Image("whos_that_pokemon")
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .frame(height: 200)
                .padding(.bottom, .small)
            
            if let url = URL(string: viewModel.displayedPokemonImageUrl ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 170)
                .offset(x: -screenWidth * 0.2)
            }
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
