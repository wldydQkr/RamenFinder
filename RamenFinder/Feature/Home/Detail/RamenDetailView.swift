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
    @ObservedObject var viewModel: HomeViewModel

    @State private var isLiked: Bool = false // 좋아요 상태
    @State private var region: MKCoordinateRegion

    init(title: String, link: String?, address: String, roadAddress: String, mapX: Double, mapY: Double, viewModel: HomeViewModel) {
        self.title = title
        self.link = link
        self.address = address
        self.roadAddress = roadAddress
        self.mapX = mapX
        self.mapY = mapY
        self.viewModel = viewModel
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: mapY, longitude: mapX),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
        
        self._isLiked = State(initialValue: viewModel.isFavorite(title: title, roadAddress: roadAddress))
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 이미지 섹션
                    AsyncImage(
                        url: URL(string: "https://img1.newsis.com/2022/10/13/NISI20221013_0001105256_web.jpg")
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                            .cornerRadius(4)
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                    }

                    // 텍스트 섹션
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)

                        Text(roadAddress)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let validLink = link, !validLink.isEmpty {
                            Link("홈페이지 방문하기", destination: URL(string: validLink)!)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)

                    // 맵뷰 섹션
                    ZStack(alignment: .bottomTrailing) {
                        DetailMapView(region: $region, mapX: mapX, mapY: mapY, locationManager: locationManager)
                            .frame(height: 300)

                        Button(action: {
                            if let userLocation = locationManager.userLocation {
                                region = MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            }
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundColor(CustomColor.primary)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 10)
                        .padding(.trailing, 20)
                    }

                    Spacer()
                }
            }

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()

                    HStack(spacing: 16) {
                        Button(action: {
                            // 공유 액션
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }

                        Button(action: {
                            // 좋아요 상태 토글 및 업데이트
                            viewModel.toggleFavorite(
                                title: title,
                                address: address,
                                roadAddress: roadAddress,
                                link: link ?? "",
                                mapX: mapX,
                                mapY: mapY
                            )
                            isLiked.toggle() // 상태 변경
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 50)

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onAppear {
            // 뷰가 나타날 때 좋아요 상태 동기화
            syncLikeStatus()
        }
    }

    // MARK: - 좋아요 상태 동기화 메서드
    private func syncLikeStatus() {
        isLiked = viewModel.isFavorite(title: title, roadAddress: roadAddress)
    }
}
