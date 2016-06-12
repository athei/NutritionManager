//
//  MainContext.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 22.07.15.
//
//

import Foundation
import CoreData
import UIKit

private let DEVMODE = true

class Database {
    // MARK: - Properties
    let moc: NSManagedObjectContext
    
    // MARK: - Private Variables
    static private let instance: Database = Database()
    
    // MARK: - Initializing
    
    private init() {
        let model = NSManagedObjectModel(contentsOfURL: Pathes.modelURL()!)!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:model)
        moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        
        // when loading the store failed it is probably because of schema change
        // we delete the data and try again
        var tries = 0;
        repeat {
            do {
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: Pathes.databaseURL(), options: nil)
                break;
            }
            catch {
                try! coordinator.destroyPersistentStoreAtURL(Pathes.databaseURL(), withType: NSSQLiteStoreType, options: nil)
                tries += 1;
            }
        } while(tries < 2)
        
        assert(coordinator.persistentStores.count == 1, "Adding persistent store failed")
        
        if (DEVMODE) {
            try! coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            insertTestData()
        } else {
            try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: Pathes.databaseURL(), options: nil)
        }
        
    }
    
    static func get() -> Database {
        return Database.instance
    }
    
    // MARK: - Public functions
    
    func createMainQueueChild() -> NSManagedObjectContext {
        return createChildContextOfType(.MainQueueConcurrencyType)
    }
    
    func createPrivateQueueChild() -> NSManagedObjectContext {
        return createChildContextOfType(.PrivateQueueConcurrencyType)
    }
    
    // MARK: - Private functions
    
    private func createChildContextOfType(type: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: type)
        context.parentContext = moc
        return context
    }
    
    private func insertTestData() {
        let ei = Ingredient(context: moc)
        let quark = Ingredient(context: moc)
        ei.name = "Ei, vom Huhn"
        ei.energy = 137
        ei.proteins = 11.9
        ei.fat = 9.3
        ei.carbohydrates = 1.5
        ei.valueScale = .Unit
        ei.image = UIImageJPEGRepresentation(UIImage(named: "egg")!, 0.8)
        
        quark.name = "Quark (40%)"
        quark.energy = 143
        quark.proteins = 11.1
        quark.fat = 11.4
        quark.carbohydrates = 2.6
        quark.valueScale = .Mass
        quark.image = UIImageJPEGRepresentation(UIImage(named: "quark")!, 0.8)
        
        var cat = Category(context: moc)
        cat.name = "Gemüse"
        cat.order = 0
        ei.category = cat
        
        cat = Category(context: moc)
        cat.name = "Putzmittel"
        cat.order = 1
        
        cat = Category(context: moc)
        cat.name = "Fleisch"
        cat.order = 2
        
        cat = Category(context: moc)
        cat.name = "Käse"
        cat.order = 3
        quark.category = cat
        
        let dreieier = DishIngredient(context: moc)
        dreieier.multiplier = 3
        dreieier.ingredient = ei
        
        let dreieier2 = DishIngredient(context: moc)
        dreieier2.multiplier = 3
        dreieier2.ingredient = ei
        
        let curryh = Dish(context: moc)
        curryh.name = "Curryhähnchen"
        curryh.directions = "Alles in die Pfanne und gut"
        curryh.ingredients = [dreieier]
        curryh.image = UIImageJPEGRepresentation(UIImage(named: "curryh")!, 0.8)
        
        let blub = Dish(context: moc)
        blub.name = "Blub"
        blub.directions = "Alles in die Pfanne und gut"
        blub.ingredients = [dreieier2]
        blub.image = UIImageJPEGRepresentation(UIImage(named: "curryh")!, 0.8)
        
        try! moc.save()
    }
    
}
