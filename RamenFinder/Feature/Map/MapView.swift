//
//  MapView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.561632, longitude: 127.06472),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var equatableRegion = EquatableMKCoordinateRegion(
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.561632, longitude: 127.06472),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )


    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: mapViewModel.annotationItems
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

            // 내 위치 버튼
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        mapViewModel.centerToUserLocation() // 내 위치로 이동
                        if let newRegion = mapViewModel.region {
                            region = newRegion
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title3)
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
            mapViewModel.requestInitialLocation()
        }
        .onChange(of: equatableRegion) { newRegion in
            region = newRegion.region
        }
        .alert(isPresented: $mapViewModel.showLocationError) {
            Alert(
                title: Text("위치 권한이 필요합니다."),
                message: Text("앱 설정에서 위치 접근 권한을 허용해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}

// 마커 식별을 위한 RamenIdentifiableCoordinate
struct RamenIdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let name: String
}

struct EquatableMKCoordinateRegion: Equatable {
    var region: MKCoordinateRegion

    static func == (lhs: EquatableMKCoordinateRegion, rhs: EquatableMKCoordinateRegion) -> Bool {
        lhs.region.center.latitude == rhs.region.center.latitude &&
        lhs.region.center.longitude == rhs.region.center.longitude &&
        lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
        lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}
