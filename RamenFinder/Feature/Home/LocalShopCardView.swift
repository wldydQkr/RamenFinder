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
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(width: 150)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    LocalShopCardView()
//}
