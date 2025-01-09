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
    let persistenceController = PersistenceController.shared // Shared PersistenceController instance

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabBar()
                    .environment(\.managedObjectContext, persistenceController.context) // Inject the context into the environment
            }
        }
    }
}
