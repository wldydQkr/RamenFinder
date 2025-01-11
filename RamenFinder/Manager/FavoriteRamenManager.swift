////
////  FavoriteRamenManager.swift
////  RamenFinder
////
////  Created by 박지용 on 1/7/25.
////
//
//import CoreData
//
//final class FavoriteRamenManager {
//    static let shared = FavoriteRamenManager()
//    private let context = PersistenceController.shared.container.viewContext
//
//    // Create or Delete Favorite
//    func toggleFavorite(shop: RamenShop) {
//        if isFavorite(shop: shop) {
//            removeFavorite(shop: shop)
//        } else {
//            addFavorite(shop: shop)
//        }
//    }
//
//    // Add Favorite
//    private func addFavorite(shop: RamenShop) {
//        let favorite = FavoriteRamenShop(context: context)
//        favorite.id = UUID()
//        favorite.name = shop.name
//        favorite.roadAddress = shop.roadAddress
//        favorite.address = shop.address
//        favorite.link = shop.link
//        favorite.mapx = shop.mapx
//        favorite.mapy = shop.mapy
//
//        saveContext()
//    }
//
//    // Remove Favorite
//    private func removeFavorite(shop: RamenShop) {
//        let request: NSFetchRequest<FavoriteRamenShop> = FavoriteRamenShop.fetchRequest()
//        request.predicate = NSPredicate(format: "name == %@", shop.name)
//
//        do {
//            let favorites = try context.fetch(request)
//            for favorite in favorites {
//                context.delete(favorite)
//            }
//            saveContext()
//        } catch {
//            print("Failed to remove favorite: \(error)")
//        }
//    }
//
//    // Check if Favorite
//    func isFavorite(shop: RamenShop) -> Bool {
//        let request: NSFetchRequest<FavoriteRamenShop> = FavoriteRamenShop.fetchRequest()
//        request.predicate = NSPredicate(format: "name == %@", shop.name)
//
//        do {
//            let count = try context.count(for: request)
//            return count > 0
//        } catch {
//            print("Failed to fetch favorite: \(error)")
//            return false
//        }
//    }
//
//    // Fetch All Favorites
//    func fetchFavorites() -> [FavoriteRamenShop] {
//        let request: NSFetchRequest<FavoriteRamenShop> = FavoriteRamenShop.fetchRequest()
//        do {
//            return try context.fetch(request)
//        } catch {
//            print("Failed to fetch favorites: \(error)")
//            return []
//        }
//    }
//
//    // Save Context
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//}
