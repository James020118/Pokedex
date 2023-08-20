# Pokédex

Pokédex is a SwiftUI application that utilizes Combine framework to retrieves data from [PokéAPI](https://pokeapi.co/).

## Screenshots



## Code Design

### UI

SwiftUI is used to make the UI portion of the app. I chose it because its easy of use. SwiftUI eliminates the use of storyboards and constraints, which makes sizing and adapting to screen sizes very easy.


Main Grid:
```swift
LazyVGrid(columns: columns, spacing: .medium) {
    ForEach(viewModel.pokemonDetails) { detail in
        PokedexGridCell(detail: detail)
            .onTapGesture {
                viewModel.didTapCell(url: detail.images.front_image)
            }
            .onAppear {
                guard !viewModel.isLoading else { return }
                // Only request and load more data if we scroll to end
                if viewModel.isLastPokemon(detail: detail) {
                    viewModel.getPokemonList()
                }
            }
    }
}
```

Grid Cell:
```swift
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
```

### View Model

View model is used for the purposes of coordinating between the view and the service. Dependency injection is used to inject the network service so testing is easy (if we had done so). 

```swift
final class PokedexGridViewModel: ObservableObject {
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
```

View model also asynchronously makes network calls and receives results using Combine. I chose Combine over completion handler because it is much easier to work with and handles async actions much better.

Pagination is also utilized for fetching list, since we only fetch 20 Pokemons at a time and store the next URL for later fetching.

```swift
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
```

### Service

Network service is responsible for making the network calls, and publishing streams of results to subscribers. 

```swift
/// Network service of the app responsible for retrieving data from external API
protocol NetworkService: AnyObject {
    /// Fetches the list of pokemons
    /// - Parameter urlString: the URL endpoint that delivers the paginated pokemon list
    /// - Returns: A publisher that publishes the API response
    func fetchList(urlString: String) -> AnyPublisher<FetchListResponse, Error>
    
    /// Fetches the detail of a specific pokemon given the url
    /// - Parameter urlString: the URL endpoint that delivers the pokemon details
    /// - Returns: A publisher that publishes the API respones (`PokemonDetail`)
    func fetchDetail(urlString: String) -> AnyPublisher<PokemonDetail, Error>
}
```

Combine is also used here to publish streams.

```swift
func fetchList(urlString: String) -> AnyPublisher<FetchListResponse, Error> {
    guard let url = URL(string: urlString) else {
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
```
