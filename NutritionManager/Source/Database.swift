//
//  MainContext.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 22.07.15.
//
//

import Foundation
import CoreData

class Database {
    static private var once = dispatch_once_t()
    static private var instance: Database?
    
    let moc: NSManagedObjectContext
    
    var storeCoordinator: NSPersistentStoreCoordinator {
        return moc.persistentStoreCoordinator!
    }
    
    
    private init() {
        let model = NSManagedObjectModel(contentsOfURL: Pathes.modelURL()!)!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:model)
        moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        
        // HACK: only for dev -> delete persistent store when loading failes
        var tries = 0;
        repeat {
            do {
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: Pathes.databaseURL(), options: nil)
                break;
            }
            catch {
                try! coordinator.destroyPersistentStoreAtURL(Pathes.databaseURL(), withType: NSSQLiteStoreType, options: nil)
                tries++;
            }
        } while(tries < 2)
        
        assert(coordinator.persistentStores.count == 1, "Adding persistent store failed")
        
        let ei = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: moc) as! Ingredient
        let quark = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: moc) as! Ingredient
        ei.name = "Ei, vom Huhn"
        ei.energy = 137
        ei.proteins = 11.9
        ei.fat = 9.3
        ei.carbohydrates = 1.5
        ei.valueScale = .Unit
        
        quark.name = "Quark (40%)"
        quark.energy = 143
        quark.proteins = 11.1
        quark.fat = 11.4
        quark.carbohydrates = 2.6
        quark.valueScale = .Mass
    }
    
    static func get() -> Database {
        dispatch_once(&Database.once) {
            Database.instance = Database()
        }
        return Database.instance!
    }
}
