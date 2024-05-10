//
//  CoreDataCustomMigrationApp.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-10.
//

import SwiftUI

@main
struct CoreDataCustomMigrationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
