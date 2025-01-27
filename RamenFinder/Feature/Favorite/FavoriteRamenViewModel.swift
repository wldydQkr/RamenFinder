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
    @Published var selectedShop: FavoriteRamen?
    private var shopCache: [UUID: FavoriteRamen] = [:] // 캐시

    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
        fetchFavorites()
    }

    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteRamen> = FavoriteRamen.fetchRequest()
        do {
            favoriteRamenShops = try container.viewContext.fetch(request)
            cacheAllShops() // 모든 데이터를 캐싱
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
        }
    }

    func cacheAllShops() {
        for shop in favoriteRamenShops {
            if let id = shop.id {
                shopCache[id] = shop
            }
        }
    }

    func cacheSelectedShopDetails(shop: FavoriteRamen) {
        selectedShop = shopCache[shop.id ?? UUID()] ?? shop
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
