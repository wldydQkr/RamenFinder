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

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var ramenShops: [RamenShop] = []
    @Published var localRamenShops: [LocalRamenShop] = []
    @Published var favoriteRamenShops: [FavoriteRamen] = []
    @Published var profileImage: UIImage? = nil // 프로필 이미지
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        setupSearchListener()
        fetchFavorites()
        loadProfileImage()
    }

    // MARK: - 프로필 이미지 로드
    func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileImage = image
        } else {
            profileImage = nil // 기본값
        }
    }

    // MARK: - 검색 텍스트 리스너 설정
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

    // MARK: - 라멘 가게 검색
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

    // MARK: - API 검색 수행
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

    // MARK: - 에러 처리
    private func handleError(error: Error) {
        print("Network or parsing error: \(error.localizedDescription)")
    }
    
    // MARK: - 좋아요 기능
    func isFavorite(title: String, roadAddress: String) -> Bool {
        favoriteRamenShops.contains(where: { $0.name == title && $0.roadAddress == roadAddress })
    }
    
    func toggleFavorite(
        title: String,
        address: String,
        roadAddress: String,
        link: String,
        mapX: Double,
        mapY: Double
    ) {
        if isFavorite(title: title, roadAddress: roadAddress) {
            removeFromFavorites(title: title, roadAddress: roadAddress)
        } else {
            addToFavorites(
                title: title,
                address: address,
                roadAddress: roadAddress,
                link: link,
                mapX: mapX,
                mapY: mapY
            )
        }
    }
    
    private func addToFavorites(
        title: String,
        address: String,
        roadAddress: String,
        link: String,
        mapX: Double,
        mapY: Double
    ) {
        let newFavorite = FavoriteRamen(context: viewContext)
        newFavorite.id = UUID()
        newFavorite.name = title
        newFavorite.address = address
        newFavorite.roadAddress = roadAddress
        newFavorite.link = link
        newFavorite.mapx = mapX
        newFavorite.mapy = mapY

        saveContext()
    }
    
    private func removeFromFavorites(title: String, roadAddress: String) {
        if let shop = favoriteRamenShops.first(where: { $0.name == title && $0.roadAddress == roadAddress }) {
            viewContext.delete(shop)
            saveContext()
        }
    }


    // MARK: - 즐겨찾기 데이터 관리
    func fetchFavorites() {
        do {
            let request: NSFetchRequest<FavoriteRamen> = FavoriteRamen.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            favoriteRamenShops = try viewContext.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
            fetchFavorites()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 즐겨찾기 삭제
    func deleteFavorite(shop: FavoriteRamen) {
        viewContext.delete(shop)
        do {
            try viewContext.save()
            fetchFavorites()
        } catch {
            print("Failed to delete favorite: \(error.localizedDescription)")
        }
    }
}
