//
//  FavoriteRamenView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import SwiftUI

struct FavoriteRamenView: View {
    @StateObject private var viewModel = FavoriteRamenViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteRamenShops, id: \.self) { shop in
                    VStack(alignment: .leading) {
                        Text(shop.name ?? "Unknown")
                            .font(.headline)
                        Text(shop.roadAddress ?? "Unknown")
                            .font(.subheadline)
                        Text(shop.address ?? "Unknown")
                            .font(.subheadline)
                    }
                    .padding()
                }
                .onDelete(perform: deleteFavorite)
            }
            .navigationTitle("좋아하는 라멘")
        }
    }

    private func deleteFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let shop = viewModel.favoriteRamenShops[index]
            viewModel.removeFavorite(shop: shop)
        }
    }
}

#Preview {
    FavoriteRamenView()
}
