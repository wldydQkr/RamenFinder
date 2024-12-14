//
//  HomeViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import Combine
import CoreLocation

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

// 근처 라멘 전용 모델
struct NearbyRamenShop: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    static func == (lhs: NearbyRamenShop, rhs: NearbyRamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var ramenShops: [RamenShop] = []       // 추천 라멘용
    @Published var nearbyRamenShops: [NearbyRamenShop] = [] // 근처 라멘용
    @Published var localRamenShops: [LocalRamenShop] = []       // 지역 라멘용
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"
    private let clientId = "NZmzvNuQwqMF1dFh9YmL"
    private let clientSecret = "UL5R8sDcrz"

    init() {
        // 실시간 검색어를 토대로 데이터 업데이트
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.fetchRamenShops(query: text)
                } else {
                    self?.ramenShops = [] // 검색어가 비어있으면 초기화
                }
            }
            .store(in: &cancellables)
    }

    func fetchRamenShopsNearby(latitude: Double, longitude: Double) {
        let query = "라멘"
        let coordinate = "\(longitude),\(latitude)" // 경도,위도 순서
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        guard let url = URL(string: "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&sort=distance&coordinate=\(coordinate)") else {
            print("유효하지 않은 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 헤더에 네이버 인증 정보 추가
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("네트워크 요청 에러: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("데이터 없음")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RamenSearchResponse.self, from: data)
                
                // 응답을 NearbyRamenShop 배열로 매핑
                let shops = response.items.compactMap { item -> NearbyRamenShop? in
                    guard let lat = item.mapy.toCoordinateDouble(),
                          let lng = item.mapx.toCoordinateDouble() else {
                        return nil
                    }
                    return NearbyRamenShop(
                        name: item.title.stripHTML(),
                        roadAddress: item.roadAddress,
                        address: item.address,
                        category: item.category,
                        link: item.link,
                        mapx: lat,
                        mapy: lng
                    )
                }

                DispatchQueue.main.async {
                    self?.nearbyRamenShops = shops
                }
            } catch {
                print("디코딩 에러: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchRamenShops(query: String) {
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
            })
            .store(in: &cancellables)
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
    
}

// 네이버 API 응답 모델
struct NaverSearchResponse: Codable {
    let items: [ShopItem]
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

// HTML 태그 제거 메서드
extension String {
    func stripHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return attributedString?.string ?? self
    }
}
