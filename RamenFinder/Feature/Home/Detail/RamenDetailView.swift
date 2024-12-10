//
//  RamenDetailView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/8/24.
//

import SwiftUI
import MapKit

struct RamenDetailView: View {
    let title: String
    let link: String
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double
    
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 상단 이미지 섹션
                ZStack(alignment: .topLeading) {
                    AsyncImage(
                        url: URL(string: "https://i.ytimg.com/vi/h-ccx94lXSE/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDuCs5orHjNXdXnBLARfzedQTwMEA")
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.height * 0.4)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.4)
                    }

                    Button(action: {
                        // 닫기 버튼 동작
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                // 텍스트 섹션
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button(action: {
                            locationManager.requestUserLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 8)
                    }

                    Text(roadAddress)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)

                    Link("웹사이트 방문하기", destination: URL(string: link)!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal) // 텍스트와 화면 가장자리 간격 조정
                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트 전체 너비와 정렬
                
                // 맵뷰 섹션
                MapView(mapX: mapX, mapY: mapY, locationManager: locationManager)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top) // 상단 이미지 확장
    }
}

struct MapView: View {
    let mapX: Double
    let mapY: Double
    @ObservedObject var locationManager: LocationManager

    struct IdentifiableCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let tint: Color
    }

    var body: some View {
        let shopCoordinate = CLLocationCoordinate2D(latitude: mapY, longitude: mapX)
        let region = MKCoordinateRegion(
            center: shopCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        // 매장 마커
        var annotationItems = [
            IdentifiableCoordinate(coordinate: shopCoordinate, tint: .red)
        ]

        // 사용자 위치가 있을 경우 마커 추가
        if let userCoordinate = locationManager.userLocation {
            annotationItems.append(IdentifiableCoordinate(coordinate: userCoordinate, tint: .blue))
        }

        return Map(coordinateRegion: .constant(region), annotationItems: annotationItems) { item in
            MapMarker(coordinate: item.coordinate, tint: item.tint)
        }
    }
}

#Preview {
    RamenDetailView(
        title: "무메노",
        link: "https://naver.com",
        address: "서울특별시 마포구 연남동",
        roadAddress: "연남동",
        mapX: 126.923739,
        mapY: 37.561632
    )
}

extension String {
    /// 문자열을 Double로 변환하고, 1e7로 나눈 좌표값으로 반환합니다.
    func toCoordinateDouble() -> Double? {
        guard let doubleValue = Double(self) else { return nil }
        return doubleValue / 1_0000000.0
    }
}
