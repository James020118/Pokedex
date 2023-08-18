//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-17.
//

import SwiftUI

@main
struct PokedexApp: App {
    let networkService = NetworkServiceImpl()

    var body: some Scene {
        WindowGroup {
            PokedexGrid(viewModel: PokedexGridViewModel(networkService: networkService))
        }
    }
}
