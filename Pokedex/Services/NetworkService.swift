//
//  NetworkService.swift
//  Pokedex
//
//  Created by Ximing Yang on 2023-08-18.
//

import Combine
import Foundation

protocol NetworkService: AnyObject {
    func fetchList() -> AnyPublisher<FetchListResponse, Error>
}

final class NetworkServiceImpl: NetworkService {
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private let session = URLSession.shared
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
            .decode(type: FetchListResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
