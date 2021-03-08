//
//  DataStoreContainer.swift
//  Planets
//
//  Created by Andrew on 06/03/21.
//

import Foundation
import CoreData

/// A singleton class containing the Persistent Store that can be used in the app
class DataStoreContainer {
    
    static let shared = DataStoreContainer()

    var persistentContainer: NSPersistentContainer!

    private init() {
        persistentContainer = NSPersistentContainer(name: "StarWars")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let coredataError = error {
                NSLog("Core Data Error - \(coredataError)")
            }
        }
    }
    
    func viewContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                NSLog("Error while trying to save the context - \(error)")
            }
        }
    }
}
