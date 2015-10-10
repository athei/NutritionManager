//
//  Dish.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 08.10.15.
//
//

import Foundation
import CoreData

class Dish: NSManagedObject, Insertable {

    // MARK: - Initializing
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName("Dish", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }

}

// MARK: - CoreData Extension

extension Dish {
    
    @NSManaged var name: String
    @NSManaged var directions: String
    @NSManaged var ingredients: NSSet
    @NSManaged var image: NSData?
    
}

