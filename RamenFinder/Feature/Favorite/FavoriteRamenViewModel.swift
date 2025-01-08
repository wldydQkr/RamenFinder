//
//  FavoriteRamenViewModel.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import Foundation
import CoreData

class FavoriteRamenViewModel: ObservableObject {
    @Published var favoriteRamenShops: [FavoriteRamen] = []

    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "RamenFinderModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
        fetchFavorites()
    }

    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteRamen> = FavoriteRamen.fetchRequest()
        do {
            favoriteRamenShops = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
        }
    }

    func addFavorite(shop: RamenShop) {
        let newFavorite = FavoriteRamen(context: container.viewContext)
        newFavorite.id = UUID()
        newFavorite.name = shop.name
        newFavorite.roadAddress = shop.roadAddress
        newFavorite.address = shop.address
        newFavorite.link = shop.link
        newFavorite.mapx = shop.mapx
        newFavorite.mapy = shop.mapy

        saveContext()
        fetchFavorites()
    }

    func removeFavorite(shop: FavoriteRamen) {
        container.viewContext.delete(shop)
        saveContext()
        fetchFavorites()
    }

    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
