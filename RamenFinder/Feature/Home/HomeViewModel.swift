//
//  HomeViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import Combine
import CoreLocation
import CoreData

// 모델 정의
struct RamenShop: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    // Equatable 요구 사항 구현
    static func == (lhs: RamenShop, rhs: RamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}

// 지역 라멘 모델 정의
struct LocalRamenShop: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    // Equatable 요구 사항 구현
    static func == (lhs: LocalRamenShop, rhs: LocalRamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var ramenShops: [RamenShop] = []
    @Published var localRamenShops: [LocalRamenShop] = []
    @Published var favoriteRamenShops: [FavoriteRamen] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"
    private let clientId = "NZmzvNuQwqMF1dFh9YmL"
    private let clientSecret = "UL5R8sDcrz"

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        setupSearchListener()
        fetchFavorites()
    }

    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { $0.count >= 2 } // 최소 두 글자 이상 입력 시 검색
            .sink { [weak self] text in
                guard let self = self else { return }
                self.fetchRamenShops(query: text)
            }
            .store(in: &cancellables)
    }

    func fetchRamenShops(query: String) {
        guard !isLoading else { return } // 중복 요청 방지

        performAPISearch(query: query) { [weak self] response in
            self?.ramenShops = response.items.map { item in
                RamenShop(
                    name: item.title.stripHTML(),
                    roadAddress: item.roadAddress,
                    address: item.address,
                    category: item.category,
                    link: item.link,
                    mapx: item.mapx.toCoordinateDouble() ?? 0,
                    mapy: item.mapy.toCoordinateDouble() ?? 0
                )
            }
        }
    }
    
    func fetchRamenShopsByCategory(category: String) {
        let query = "\(category) 라멘" // 카테고리 이름 + 라멘
        guard !query.isEmpty else { return }
        
        isLoading = true

        // URL 구성
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "5"),
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "sort", value: "random")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

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
                    print("Error fetching shops: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.localRamenShops = response.items.map { item in
                    LocalRamenShop(
                        name: item.title.stripHTML(),
                        roadAddress: item.roadAddress,
                        address: item.address,
                        category: item.category,
                        link: item.link,
                        mapx: item.mapx.toCoordinateDouble() ?? 0,
                        mapy: item.mapy.toCoordinateDouble() ?? 0
                    )
                }
            })
            .store(in: &cancellables)
    }

    private func performAPISearch(query: String, completion: @escaping (RamenSearchResponse) -> Void) {
        guard !query.isEmpty else { return }

        isLoading = true

        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "5"),
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "sort", value: "random")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: RamenSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionState in
                self?.isLoading = false
                if case .failure(let error) = completionState {
                    self?.handleError(error: error)
                }
            }, receiveValue: { response in
                completion(response)
            })
            .store(in: &cancellables)
    }

    private func handleError(error: Error) {
        print("Network or parsing error: \(error.localizedDescription)")
    }

    func fetchFavorites() {
        do {
            let request: NSFetchRequest<FavoriteRamen> = FavoriteRamen.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            favoriteRamenShops = try viewContext.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
        }
    }

    func deleteFavorite(shop: FavoriteRamen) {
        viewContext.delete(shop)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
            fetchFavorites()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

struct ShopItem: Codable {
    let title: String
    let roadAddress: String
    let address: String
    let category: String
    let mapx: String
    let mapy: String
}

struct RamenShopResponse: Codable {
    let title: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String
    let mapx: String
    let mapy: String
}

struct RamenSearchResponse: Codable {
    let items: [RamenShopResponse]
}
