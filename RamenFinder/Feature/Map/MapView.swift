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
        center: CLLocationCoordinate2D(latitude: 37.561632, longitude: 127.06472),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @StateObject private var locationManager = LocationManager()

    let ramenShops: [RamenIdentifiableCoordinate] = [
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5628, longitude: 127.0635),
            tint: .red,
            name: "라멘 가게 1"
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5612, longitude: 127.0652),
            tint: .blue,
            name: "라멘 가게 2"
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5605, longitude: 127.0667),
            tint: .green,
            name: "라멘 가게 3"
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5630, longitude: 127.0620),
            tint: .orange,
            name: "라멘 가게 4"
        ),
        RamenIdentifiableCoordinate(
            coordinate: CLLocationCoordinate2D(latitude: 37.5625, longitude: 127.0640),
            tint: .purple,
            name: "라멘 가게 5"
        )
    ]

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: ramenShops
            ) { item in
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
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        moveToUserLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .padding()
                            .background(.white)
                            .tint(CustomColor.primary)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding([.bottom, .trailing], 12)
                }
            }
        }
        .onAppear {
            locationManager.requestUserLocation()
            updateInitialRegion()
        }
        .alert(isPresented: .constant(locationManager.isAuthorizationDenied)) {
            Alert(
                title: Text("위치 권한이 필요합니다."),
                message: Text("앱 설정에서 위치 접근 권한을 허용해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }

    private func updateInitialRegion() {
        if let userLocation = locationManager.userLocation {
            region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }

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
    let name: String // 매장 이름 추가
}
