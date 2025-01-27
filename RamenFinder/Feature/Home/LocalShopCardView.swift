//
//  LocalShopCardView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/11/24.
//

import SwiftUI

struct LocalShopCardView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String
    let link: String
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double
    let selectedCategory: String // 선택된 카테고리 제목

    @ObservedObject var viewModel: HomeViewModel
    @State private var isLiked: Bool = false

    var body: some View {
        NavigationLink(destination: RamenDetailView(
            title: title,
            link: link,
            address: address,
            roadAddress: roadAddress,
            mapX: mapX,
            mapY: mapY,
            viewModel: viewModel
        )) {
            ZStack(alignment: .bottomLeading) {
                // 배경 이미지
                if let imageURL = imageURL {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 200)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 200)
                            .background(Color.gray.opacity(0.2))
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 200)
                        .background(Color.gray.opacity(0.2))
                }

                // 오버레이
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // 카테고리 제목 표시
                            Text(selectedCategory)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                        Spacer()

                        // 좋아요 버튼
                        Button(action: {
                            viewModel.toggleFavorite(
                                title: title,
                                address: address,
                                roadAddress: roadAddress,
                                link: link,
                                mapX: mapX,
                                mapY: mapY
                            )
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(isLiked ? .red : .white)
                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(7)
            }
            .frame(width: 150, height: 200)
            .cornerRadius(7)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 1)
            .onAppear {
                isLiked = viewModel.isFavorite(title: title, roadAddress: roadAddress)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
