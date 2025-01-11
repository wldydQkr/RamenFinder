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

    @State private var isLiked: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FavoriteRamen.entity(),
        sortDescriptors: []
    ) private var favoriteRamenShops: FetchedResults<FavoriteRamen>

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
                        toggleLikeStatus()
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
                isLiked = isFavorite()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Helper Functions
    private func toggleLikeStatus() {
        if isLiked {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
        isLiked.toggle()
    }

    private func isFavorite() -> Bool {
        favoriteRamenShops.contains(where: { $0.name == title && $0.roadAddress == roadAddress })
    }

    private func addToFavorites() {
        let newFavorite = FavoriteRamen(context: viewContext)
        newFavorite.id = UUID()
        newFavorite.name = title
        newFavorite.roadAddress = roadAddress
        newFavorite.address = address
        newFavorite.link = link
        newFavorite.mapx = mapX
        newFavorite.mapy = mapY

        saveContext()
    }

    private func removeFromFavorites() {
        if let shop = favoriteRamenShops.first(where: { $0.name == title && $0.roadAddress == roadAddress }) {
            viewContext.delete(shop)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
