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
    
    required init(context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entityForName("Dish", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }

}

// MARK: - CoreData Extension

extension Dish {
    
    @NSManaged var name: String
    @NSManaged var directions: String
    @NSManaged var ingredients: NSSet
    
}

