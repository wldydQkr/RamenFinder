//
//  DetailMapView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/12/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct DetailMapView: View {
    @Binding var region: MKCoordinateRegion
    let mapX: Double
    let mapY: Double
    let name: String
    @ObservedObject var locationManager: LocationManager

    struct IdentifiableCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let tint: Color
        let name: String
    }

    var body: some View {
        // 라멘 위치 마커
        let shopCoordinate = CLLocationCoordinate2D(latitude: mapY, longitude: mapX)
        let annotationItems = [
            IdentifiableCoordinate(coordinate: shopCoordinate, tint: .red, name: name) // 가게 위치 마커
        ]

        return Map(
            coordinateRegion: $region,
            showsUserLocation: true, // 사용자 위치를 동그라미로 표시
            annotationItems: annotationItems
        ) { item in
            // 가게 위치 마커를 표시
            MapAnnotation(coordinate: item.coordinate) {
                VStack {
                    Text(item.name)
                        .font(.caption)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)

                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(item.tint)
                        .shadow(radius: 4)
                }
            }
        }
        .frame(height: 300)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

//#Preview {
//    RamenDetailView(
//        title: "무메노",
//        link: "https://naver.com",
//        address: "서울특별시 마포구 연남동",
//        roadAddress: "연남동",
//        mapX: 126.923739,
//        mapY: 37.561632,
//        viewModel: HomeViewModel()
//    )
//}
