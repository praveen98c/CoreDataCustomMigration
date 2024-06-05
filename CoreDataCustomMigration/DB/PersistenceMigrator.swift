//
//  PersistenceMigrator.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-06-04.
//

import Foundation
import CoreData

enum DatabaseError: Error {
    case sourceModel
    case mappingModel
    case retrievingManagedObjectModels
    case managedObjectModel
}

protocol PersistenceMigratorProtocol {
    func migrateIteratively(dataStoreURL: URL) throws
}

class PersistenceMigrator: PersistenceMigratorProtocol {
    
    let documentsDirectory: URL
    let dbName: String
    
    init(documentsDirectory: URL, dbName: String) {
        self.documentsDirectory = documentsDirectory
        self.dbName = dbName
    }
    
    func migrateIteratively(dataStoreURL: URL) throws {
        let temporaryDataStoreURL = documentsDirectory.appendingPathComponent("TemporaryCoreDataMigration.sqlite")
        guard
            let bundle = Bundle.main.url(forResource: dbName,
                                         withExtension: "momd"),
            let finalManagedObjectModel = NSManagedObjectModel(contentsOf: bundle) else {
            throw DatabaseError.managedObjectModel
        }
        
        var sourceMetadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(type: .sqlite,
                                                                                         at: dataStoreURL)
        while !finalManagedObjectModel.isConfiguration(withName: nil,
                                                       compatibleWithStoreMetadata: sourceMetadata) {
            guard let sourceModel = NSManagedObjectModel.mergedModel(from: [Bundle.main],
                                                                     forStoreMetadata: sourceMetadata) else {
                throw DatabaseError.sourceModel
            }
            
            guard let (destinationModel, mappingModel) = try getDestinationModelAndMappingModel(for: sourceModel) else {
                throw DatabaseError.mappingModel
            }
            
            let migrationManager = NSMigrationManager(sourceModel: sourceModel,
                                                      destinationModel: destinationModel)
            if FileManager.default.fileExists(atPath: temporaryDataStoreURL.path) {
                try FileManager.default.removeItem(at: temporaryDataStoreURL)
            }
            
            try migrationManager.migrateStore(from: dataStoreURL,
                                              sourceType: NSSQLiteStoreType,
                                              options: nil,
                                              with: mappingModel,
                                              toDestinationURL: temporaryDataStoreURL,
                                              destinationType: NSSQLiteStoreType,
                                              destinationOptions: nil)
            try FileManager.default.removeItem(at: dataStoreURL)
            try FileManager.default.moveItem(at: temporaryDataStoreURL, to: dataStoreURL)
            sourceMetadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(type: .sqlite, at: dataStoreURL)
        }
    }
    
    func getDestinationModelAndMappingModel(for sourceModel: NSManagedObjectModel) throws -> (NSManagedObjectModel, NSMappingModel)? {
        let managedObjectModelURLs = try retrieveManagedObjectModelURLs()
        for url in managedObjectModelURLs {
            guard let destinationModel = NSManagedObjectModel(contentsOf: url) else {
                throw DatabaseError.managedObjectModel
            }
 
            if let mappingModel = NSMappingModel(from: [Bundle.main],
                                                 forSourceModel: sourceModel,
                                                 destinationModel: destinationModel) {
                return (destinationModel, mappingModel)
            }
        }
        
        return nil
    }
    
    func retrieveManagedObjectModelURLs() throws -> [URL] {
        guard let momdURL = Bundle.main.url(forResource: dbName, withExtension: "momd") else {
            throw DatabaseError.retrievingManagedObjectModels
        }

        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: momdURL.path)
            var urls = [URL]()
            for path in contents {
                if path.hasSuffix(".mom") {
                    urls.append(URL(fileURLWithPath: path, relativeTo: momdURL))
                }
            }
            
            return urls
        } catch {
            throw DatabaseError.retrievingManagedObjectModels
        }
    }
}
