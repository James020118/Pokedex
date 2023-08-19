//
//  NetworkService.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import Combine
import Foundation

/// Network service of the app responsible for retrieving data from external API
protocol NetworkService: AnyObject {
    /// Fetches the list of pokemons
    /// - Returns: A publisher that publishes the API response
    func fetchList() -> AnyPublisher<FetchListResponse, Error>
    
    /// Fetches the detail of a specific pokemon given the url
    /// - Parameter urlString: the URL endpoint that delivers the pokemon details
    /// - Returns: A publisher that publishes the API respones (`PokemonDetail`)
    func fetchDetail(urlString: String) -> AnyPublisher<PokemonDetail, Error>
}

final class NetworkServiceImpl: NetworkService {
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()
}

extension NetworkServiceImpl {
    func fetchList() -> AnyPublisher<FetchListResponse, Error> {
        guard let url = URL(string: baseURL.appending("?limit=20&offset=0")) else {
            return Fail<FetchListResponse, Error>(error: NSError()).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            // the dataTaskPublisher output combination is (data: Data, response: URLResponse)
            // we only need to keep the data
            .map { data, _ in
                return data
            }
            .decode(type: FetchListResponse.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func fetchDetail(urlString: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: urlString) else {
            return Fail<PokemonDetail, Error>(error: NSError()).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            // the dataTaskPublisher output combination is (data: Data, response: URLResponse)
            // we only need to keep the data
            .map { data, _ in
                return data
            }
            .decode(type: PokemonDetail.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
