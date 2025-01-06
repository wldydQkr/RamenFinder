//
//  MapView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.561632, longitude: 127.06472), // 초기 지도 중심: 장한평역
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @StateObject private var locationManager = LocationManager() // 사용자 위치 관리

    // 고정된 라멘 가게 데이터
    let ramenShops: [RamenIdentifiableCoordinate] = [
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5628, longitude: 127.0635),
            tint: .red
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5612, longitude: 127.0652),
            tint: .red
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5605, longitude: 127.0667),
            tint: .red
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5630, longitude: 127.0620),
            tint: .red
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5625, longitude: 127.0640),
            tint: .red
        )
    ]

    var body: some View {
        ZStack {
            // Map 뷰
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: ramenShops
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Circle()
                        .fill(item.tint)
                        .frame(width: 10, height: 10)
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // 내 위치로 돌아가는 버튼
                    Button(action: {
                        moveToUserLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 10)
                }
            }
        }
        .onAppear {
            locationManager.requestUserLocation()
        }
        .alert(isPresented: .constant(locationManager.isAuthorizationDenied)) {
            Alert(
                title: Text("위치 권한이 필요합니다."),
                message: Text("앱 설정에서 위치 접근 권한을 허용해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }

    // 사용자 위치로 이동
    private func moveToUserLocation() {
        guard let userLocation = locationManager.userLocation else {
            print("사용자 위치를 가져올 수 없습니다.")
            return
        }
        region = MKCoordinateRegion(
            center: userLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

// 마커 식별을 위한 IdentifiableCoordinate
struct RamenIdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
}
