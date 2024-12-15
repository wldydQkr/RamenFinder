//
//  MapViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import Foundation
import CoreLocation
import Combine
import MapKit

struct NearbyRamenShop: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let roadAddress: String
    let address: String
    let category: String
    let link: String?
    let mapx: Double
    let mapy: Double

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case roadAddress
        case address
        case category
        case link
        case mapx
        case mapy
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawName = try container.decode(String.self, forKey: .name)
        name = rawName.stripHTML()
        
        roadAddress = try container.decode(String.self, forKey: .roadAddress)
        address = try container.decode(String.self, forKey: .address)
        category = try container.decode(String.self, forKey: .category)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        
        // 좌표값 처리
        if let mapxString = try? container.decode(String.self, forKey: .mapx),
           let mapyString = try? container.decode(String.self, forKey: .mapy),
           let mapxValue = Double(mapxString),
           let mapyValue = Double(mapyString) {
            mapx = mapxValue / 1_000_000.0
            mapy = mapyValue / 1_000_000.0
        } else {
            throw DecodingError.dataCorruptedError(forKey: .mapx, in: container, debugDescription: "Invalid mapx or mapy value")
        }
    }
}

struct NaverAPIResponse: Decodable {
    let items: [NearbyRamenShop]
}

@MainActor
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var ramenShops: [NearbyRamenShop] = []
    @Published var region: MKCoordinateRegion? // 맵뷰의 현재 중심 위치
    private let locationManager = CLLocationManager()

    private let clientId = "NZmzvNuQwqMF1dFh9YmL"
    private let clientSecret = "UL5R8sDcrz"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestInitialLocation() {
        // 초기 위치 요청
        locationManager.requestLocation()
    }

    func requestUserLocation() {
        // 버튼 클릭 시 위치 요청
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let coordinate = location.coordinate
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        // 주변 라멘 매장 가져오기
        fetchNearbyRamenShops(lat: coordinate.latitude, lon: coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch user location: \(error.localizedDescription)")
    }

    /// 네이버 API로 라멘 매장 데이터를 가져오는 메서드
    func fetchNearbyRamenShops(lat: Double, lon: Double) {
        let baseURL = "https://openapi.naver.com/v1/search/local.json"
        let query = "라멘"
        let urlString = "\(baseURL)?query=\(query)&display=5&coordinate=\(lon),\(lat)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }

        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching ramen shops: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            // Debugging: Print raw JSON data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NaverAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.ramenShops = response.items
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
