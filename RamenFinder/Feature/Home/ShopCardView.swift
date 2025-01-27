//
//  ShopCardView.swift
//  RamenFinder
//
//  Created by 박지용 on 12/10/24.
//

import SwiftUI
import CoreData

struct ShopCardView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String
    let link: String
    let address: String
    let roadAddress: String
    let mapX: Double
    let mapY: Double

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
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
                                .cornerRadius(10)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 100)
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .clipped()
                    }

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
                            .font(.title2)
                            .foregroundColor(isLiked ? .pink : .white)
                            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
                            .padding(8)
                    }
                }

                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 150)
            .onAppear {
                isLiked = viewModel.isFavorite(title: title, roadAddress: roadAddress)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
