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

    @State private var isLiked: Bool = false

    var body: some View {
        NavigationLink(destination: RamenDetailView(
            title: title,
            link: link,
            address: address,
            roadAddress: roadAddress,
            mapX: mapX,
            mapY: mapY
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
                    
                    // 좋아요 버튼
                    HStack {
                        Spacer()
                        Button(action: {
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
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}
