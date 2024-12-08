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

class HomeViewModel: ObservableObject {
    @Published var ramenShops: [RamenShop] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://openapi.naver.com/v1/search/local.json"
    private let clientID = "NZmzvNuQwqMF1dFh9YmL"
    private let clientSecret = "UL5R8sDcrz"

    func fetchRamenShops(isNextPage: Bool = false) {
        print("fetchRamenShops 호출됨. isNextPage: \(isNextPage)")
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        // 다음 페이지를 요청할 경우 페이지 증가
        if isNextPage {
            currentPage += 1
        }

        let queryItems = [
            URLQueryItem(name: "query", value: "서울 라멘"),
            URLQueryItem(name: "display", value: "5"),
            URLQueryItem(name: "start", value: "\(currentPage * 5 - 4)"), // 시작 지점 계산
            URLQueryItem(name: "sort", value: "random")
        ]

        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            self.errorMessage = "잘못된 URL입니다."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NaverSearchResponse.self, decoder: JSONDecoder())
            .map { response in
                response.items.map { item in
                    RamenShop(
                        name: item.title.stripHTML(),
                        roadAddress: item.roadAddress,
                        address: item.address,
                        category: item.category,
                        latitude: Double(item.mapy) ?? 0.0, // 위도
                        longitude: Double(item.mapx) ?? 0.0 // 경도
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] shops in
                if isNextPage {
                    // 중복 제거 후 추가
                    let newShops = shops.filter { !self!.ramenShops.contains($0) }
                    self?.ramenShops.append(contentsOf: newShops)
                } else {
                    self?.ramenShops = shops
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
