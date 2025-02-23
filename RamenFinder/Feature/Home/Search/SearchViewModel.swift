//
//  SearchViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/8/24.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [RamenShop] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if !query.isEmpty {
                    self.performSearch(query: query)
                } else {
                    self.searchResults = []
                }
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) {
        guard !query.isEmpty else { return }

        isLoading = true
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "20")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(NaverAPIKey.clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(NaverAPIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: RamenSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Search error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.searchResults = response.items.map {
                    RamenShop(
                        imageURL: "h",
                        name: $0.title.stripHTML(),
                        roadAddress: $0.roadAddress,
                        address: $0.address,
                        category: $0.category,
                        link: $0.link,
                        mapx: $0.mapx.toCoordinateDouble() ?? 0,
                        mapy: $0.mapy.toCoordinateDouble() ?? 0
                    )
                }
            })
            .store(in: &cancellables)
    }
}
