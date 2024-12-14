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
    let link: String?
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double

    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) var dismiss

    @State private var region: MKCoordinateRegion

    init(title: String, link: String?, address: String, roadAddress: String, mapX: Double, mapY: Double) {
        self.title = title
        self.link = link
        self.address = address
        self.roadAddress = roadAddress
        self.mapX = mapX
        self.mapY = mapY
        // 초기 위치를 매장 좌표로 설정
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: mapY, longitude: mapX),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                topBar
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
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity) // 이미지를 SafeArea 안에서 표시
                .edgesIgnoringSafeArea(.top)
                
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
                            // 사용자 위치 버튼을 눌렀을 때만 맵 업데이트
                            if let userLocation = locationManager.userLocation {
                                region = MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            }
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
                    
                    if let validLink = link, !validLink.isEmpty {
                        Link("웹사이트 방문하기", destination: URL(string: validLink)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 맵뷰 섹션
                MapView(region: $region, mapX: mapX, mapY: mapY, locationManager: locationManager)
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
    
    private var topBar: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(CustomColor.text)
                        .font(.title3)
                }
                .padding(.leading)

                Spacer()
            }

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(CustomColor.text)
        }
        .frame(height: 60)
        .background(Color.white)
        .overlay(
            Divider(), alignment: .bottom
        )
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    let mapX: Double
    let mapY: Double
    @ObservedObject var locationManager: LocationManager

    struct IdentifiableCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let tint: Color
    }

    var body: some View {
        // 라멘 위치 마커
        let shopCoordinate = CLLocationCoordinate2D(latitude: mapY, longitude: mapX)
        let annotationItems = [
            IdentifiableCoordinate(coordinate: shopCoordinate, tint: .red) // 가게 위치 마커
        ]

        return Map(
            coordinateRegion: $region,
            showsUserLocation: true, // 사용자 위치를 동그라미로 표시
            annotationItems: annotationItems
        ) { item in
            // 가게 위치 마커를 표시
            MapMarker(coordinate: item.coordinate, tint: item.tint)
        }
        .frame(height: 300)
        .cornerRadius(10)
        .padding(.horizontal)
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
