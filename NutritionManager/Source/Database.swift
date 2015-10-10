//
//  MainContext.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 22.07.15.
//
//

import Foundation
import CoreData

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
        
        quark.name = "Quark (40%)"
        quark.energy = 143
        quark.proteins = 11.1
        quark.fat = 11.4
        quark.carbohydrates = 2.6
        quark.valueScale = .Mass
        
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
        
        let spiegelei = Dish(context: moc)
        spiegelei.name = "Spiegelei"
        spiegelei.directions = "Alles in die Pfanne und gut"
        spiegelei.ingredients = [dreieier]
        
        try! moc.save()
    }
    
}
