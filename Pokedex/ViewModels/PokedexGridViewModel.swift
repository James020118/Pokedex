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

    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    private var pokemons: [Pokemon] = []
}

// MARK: - Actions

extension PokedexGridViewModel {
    func didTapCell(url: String) {
        displayedPokemonImageUrl = url
    }
}

// MARK: - Network calls

extension PokedexGridViewModel {
    func getPokemonList() {
        networkService.fetchList()
            .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.pokemons.forEach {
                            self?.getPokemonDetail(url: $0.url)
                        }
                        break
                    case .failure(let error):
                        // Some error handling here
                        print("received error: ", error)
                    }
            }, receiveValue: { [weak self] response in
                self?.pokemons.append(contentsOf: response.results)
            })
            .store(in: &cancellables)
    }
    
    func getPokemonDetail(url: String) {
        networkService.fetchDetail(urlString: url)
            // Need to receive on main thread since this causes UI changes
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
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
