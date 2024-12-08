//
//  HomeViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import Combine

// 모델 정의
struct RamenShop: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let latitude: Double
    let longitude: Double

    // Equatable 요구 사항 구현
    static func == (lhs: RamenShop, rhs: RamenShop) -> Bool {
        return lhs.name == rhs.name && lhs.roadAddress == rhs.roadAddress
    }
}

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var ramenShops: [RamenShop] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"
    private let clientId = "NZmzvNuQwqMF1dFh9YmL" // 네이버 API 클라이언트 ID
    private let clientSecret = "UL5R8sDcrz" // 네이버 API 클라이언트 시크릿

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

    func fetchRamenShops(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true

        // URL 구성
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "20"), // 최대 20개 결과
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
                        latitude: 0,
                        longitude: 0
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
