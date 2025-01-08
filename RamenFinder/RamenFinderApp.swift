//
//  RamenFinderApp.swift
//  RamenFinder
//
//  Created by 박지용 on 12/7/24.
//

import SwiftUI
import CoreData

@main
struct RamenFinderApp: App {
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "RamenFinderModel") // 모델 이름 확인
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Core Data initialization error: \(error), \(error.userInfo)")
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabBar()
                    .environment(\.managedObjectContext, persistentContainer.viewContext)
            }
        }
    }
}
