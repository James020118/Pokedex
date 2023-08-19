//
//  PokedexGridViewModel.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import Combine
import Foundation

final class PokedexGridViewModel: ObservableObject {
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    @Published var pokemonDetails: [PokemonDetail] = []
    @Published var displayedPokemonImageUrl: String? = nil
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    private var nextUrl: String = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"

    private var newFetchedPokemons: [Pokemon] = []
}

// MARK: - Actions

extension PokedexGridViewModel {
    func didTapCell(url: String) {
        displayedPokemonImageUrl = url
    }

    func isLastPokemon(detail: PokemonDetail) -> Bool {
        let index = pokemonDetails.firstIndex(of: detail)
        return index == pokemonDetails.count - 1
    }
}

// MARK: - Network calls

extension PokedexGridViewModel {
    func getPokemonList() {
        guard !nextUrl.isEmpty else { return }
        isLoading = true
        networkService.fetchList(urlString: nextUrl)
            .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.getPokemonDetail(
                            of: self?.newFetchedPokemons ?? [],
                            at: 0
                        )
                    case .failure(let error):
                        // Some error handling here
                        print("received error: ", error)
                    }
            }, receiveValue: { [weak self] response in
                self?.newFetchedPokemons = response.results
                self?.nextUrl = response.next
            })
            .store(in: &cancellables)
    }
    
    func getPokemonDetail(of pokemons: [Pokemon], at: Int) {
        if at == pokemons.count {
            // Fetched all details, set loading to false and return
            isLoading = false
            return
        }
        networkService.fetchDetail(urlString: pokemons[at].url)
            // Need to receive on main thread since this causes UI changes
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        // Recursively get the detail so that cells are in order
                        self?.getPokemonDetail(of: pokemons, at: at + 1)
                    case .failure(let error):
                        // Some error handling here
                        print("received error: ", error)
                    }
            }, receiveValue: { [weak self] response in
                self?.pokemonDetails.append(response)
            })
            .store(in: &cancellables)
    }
}
