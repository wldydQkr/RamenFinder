//
//  MapView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/14/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel() // MapViewModel 인스턴스

    var body: some View {
        ZStack {
            if let region = viewModel.region {
                // 맵뷰 생성
                Map(
                    coordinateRegion: .constant(region),
                    showsUserLocation: true,
                    annotationItems: viewModel.annotationItems
                ) { item in
                    // 마커 추가
                    MapMarker(coordinate: item.coordinate, tint: item.tint)
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                // 로딩 상태 표시
                Text("Loading map...")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.requestInitialLocation() // 사용자 위치 요청 및 초기 데이터 로드
        }
        .alert(isPresented: $viewModel.showLocationError) {
            Alert(
                title: Text("Location Error"),
                message: Text("Unable to fetch your location. Please check your settings."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//#Preview {
//    MapView()
//}
