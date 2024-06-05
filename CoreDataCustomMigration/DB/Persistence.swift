//
//  Persistence.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-10.
//

import CoreData

struct PersistenceController {

    private let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext
    
    private let dbName = "CoreDataCustomMigration"
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Error Documents Directory")
        }
        
        let dataStoreURL = documentsDirectory.appendingPathComponent("\(dbName).sqlite")
        container = NSPersistentContainer(name: dbName)
        container.persistentStoreDescriptions.first!.url = dataStoreURL
        
        if let description = container.persistentStoreDescriptions.first {
            description.shouldInferMappingModelAutomatically = false
            description.shouldMigrateStoreAutomatically = false
        }
        
        do {
            try PersistenceMigrator(documentsDirectory: documentsDirectory, dbName: dbName).migrateIteratively(dataStoreURL: dataStoreURL)
        } catch {
            if error is DatabaseError {
                fatalError("DB Migration Failed \(error)")
            }
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
    }
    
    func save() throws {
        try viewContext.performAndWait {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        }
    }
}
