//
//  MapView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            if let region = viewModel.region {
                // 지도 설정
                Map(
                    coordinateRegion: .constant(region),
                    interactionModes: .all,
                    showsUserLocation: true, // 내 위치 표시
                    annotationItems: viewModel.ramenShops
                ) { shop in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(latitude: shop.mapy, longitude: shop.mapx)
                    ) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            Text(shop.name)
                                .font(.caption)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(5)
                        }
                    }
                }
                .ignoresSafeArea()
            } else {
                Text("위치를 불러오는 중입니다...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            // 내 위치 버튼
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.requestUserLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 3)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.requestInitialLocation()
        }
    }
}

#Preview {
    MapView()
}
