//
//  MapViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
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
    @Published var userLocation: CLLocationCoordinate2D? // 사용자 위치 저장
    @Published var ramenShops: [NearbyRamenShop] = [] // 파싱된 매장 데이터
    @Published var region: MKCoordinateRegion? // 맵뷰의 현재 중심 위치
    @Published var annotationItems: [IdentifiableCoordinate] = [] // 맵 마커 리스트
    @Published var showLocationError: Bool = false // 위치 권한 에러 플래그

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestInitialLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = location.coordinate
        
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }

        // 현재 사용자 위치를 기준으로 맵 중앙 설정
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        print(coordinate.latitude, coordinate.longitude)
        // 주변 라멘 매장 데이터 가져오기
        fetchNearbyRamenShops(lat: coordinate.latitude, lon: coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch user location: \(error.localizedDescription)")
    }

    /// 네이버 API로 라멘 매장 데이터 가져오기
    func fetchNearbyRamenShops(lat: Double, lon: Double) {
        // 네이버 API 요청 URL 생성
        let baseURL = "https://openapi.naver.com/v1/search/local.json"
        let query = "장안동 라멘"
//        let urlString = "\(baseURL)?query=\(query)&display=5&coordinate=\(lon),\(lat)"
        let urlString = "\(baseURL)?query=\(query)&display=5"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "query", value: "라멘"),
            URLQueryItem(name: "display", value: "10"), // 결과 갯수
            URLQueryItem(name: "sort", value: "random"), // 정렬 방식
//            URLQueryItem(name: "coordinate", value: "\(longitude),\(latitude)") // 경도,위도
        ]

        var request = URLRequest(url: components.url!)
        request.addValue("NZmzvNuQwqMF1dFh9YmL", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("UL5R8sDcrz", forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching ramen shops: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NaverAPIResponse.self, from: data)
                print("Fetched shops: \(response.items.count)")
                
                // 메인 스레드에서 데이터 업데이트
                DispatchQueue.main.async {
                    self?.ramenShops = response.items
                    self?.updateAnnotations()
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    /// 매장 데이터를 기반으로 마커 업데이트
    func updateAnnotations() {
        annotationItems = ramenShops.compactMap { shop in
            guard shop.mapx != 0, shop.mapy != 0 else {
                print("Invalid coordinate for shop: \(shop.name)")
                return nil
            }
            return IdentifiableCoordinate(
                coordinate: CLLocationCoordinate2D(latitude: shop.mapy, longitude: shop.mapx),
                tint: .red
            )
        }
        print("Updated annotations: \(annotationItems.count) items.")
    }
}

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
}
