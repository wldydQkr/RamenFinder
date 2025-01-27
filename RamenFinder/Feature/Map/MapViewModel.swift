//
//  MapViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct NaverAPIResponse: Decodable {
    let items: [NearbyRamenShop]
}

@MainActor
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D? // 사용자 위치 저장
    @Published var region: MKCoordinateRegion? // 맵뷰의 현재 중심 위치
    @Published var annotationItems: [RamenIdentifiableCoordinate] = [] // 맵 마커 리스트
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
        
        DispatchQueue.main.async {
            self.userLocation = coordinate
            self.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            print("위도:\(coordinate.latitude), 경도:\(coordinate.longitude)")
        }

        // 현재 사용자 위치를 기준으로 매장 데이터 검색
        fetchNearbyRamenShops(lat: coordinate.latitude, lon: coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch user location: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.showLocationError = true
        }
    }

    func fetchNearbyRamenShops(lat: Double, lon: Double) {
        let baseURL = "https://openapi.naver.com/v1/search/local.json"
        guard var components = URLComponents(string: baseURL) else {
            print("Invalid URL components.")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: "합정 라멘"),
            URLQueryItem(name: "display", value: "5"),
            URLQueryItem(name: "coordinate", value: "\(lon),\(lat)")
        ]

        guard let url = components.url else {
            print("Invalid URL.")
            return
        }

        var request = URLRequest(url: url)
        request.addValue(NaverAPIKey.clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(NaverAPIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
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
                print("Fetched shops: \(response.items.count)") // 확인 로그

                // 메인 스레드에서 데이터 업데이트
                DispatchQueue.main.async {
                    self?.updateAnnotations(from: response.items)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    func updateAnnotations(from shops: [NearbyRamenShop]) {
        annotationItems = shops.compactMap { shop in
            // 좌표값이 한 자리씩 밀려 있는 경우 보정
            let correctedX = shop.mapx / 10.0
            let correctedY = shop.mapy / 10.0
            
            print("Converting \(shop.name):")
            print("  Original - x: \(shop.mapx), y: \(shop.mapy)")
            print("  Corrected - x: \(correctedX), y: \(correctedY)")

            // 보정된 좌표를 그대로 사용하여 마커 생성
            return RamenIdentifiableCoordinate(
                coordinate: CLLocationCoordinate2D(latitude: correctedY, longitude: correctedX),
                tint: .red,
                name: shop.name
            )
        }
        print("Updated annotations: \(annotationItems.count) items.")
    }

    func centerToUserLocation() {
        guard let userLocation = userLocation else {
            print("사용자 위치를 가져올 수 없습니다.")
            return
        }

        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}
