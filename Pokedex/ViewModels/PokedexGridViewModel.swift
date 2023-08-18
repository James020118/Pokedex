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

    @Published var pokemons: [Pokemon] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
}

extension PokedexGridViewModel {
    func getPokemonList() {
        networkService.fetchList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                    print(".sink() received the completion", String(describing: completion))
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("received error: ", error)
                    }
            }, receiveValue: { [weak self] response in
                self?.pokemons = response.results
            })
            .store(in: &cancellables)
    }
}
