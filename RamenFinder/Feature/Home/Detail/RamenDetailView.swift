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
        topBar
        ScrollView {
            VStack(spacing: 20) {
                //MARK: 상단 이미지 섹션
                ZStack(alignment: .topLeading) {
                    AsyncImage(
                        url: URL(string: "https://img1.newsis.com/2022/10/13/NISI20221013_0001105256_web.jpg")
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 12, height: 300) // 화면 너비에서 양옆 12씩 뺀 크기
                            .clipped()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width - 12, height: 300) // 동일한 크기
                    }
                }
                .padding(.horizontal, 12)
                
                //MARK: 텍스트 섹션
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
                        Link("홈페이지 방문하기", destination: URL(string: validLink)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //MARK: 맵뷰 섹션
                DetailMapView(region: $region, mapX: mapX, mapY: mapY, locationManager: locationManager)
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
