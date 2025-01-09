//
//  FavoriteRamenView.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import SwiftUI
import CoreData

struct FavoriteRamenView: View {
    @StateObject private var viewModel: FavoriteRamenViewModel

    // Initializer to inject the ViewModel
    init(container: NSPersistentContainer) {
        _viewModel = StateObject(wrappedValue: FavoriteRamenViewModel(container: container))
    }

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
    // Provide a preview using an in-memory Core Data store for testing
    let testContainer = PersistenceController(inMemory: true).container
    return FavoriteRamenView(container: testContainer)
}
