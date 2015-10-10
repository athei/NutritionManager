//
//  DishIngredient.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 08.10.15.
//
//

import Foundation
import CoreData

class DishIngredient: NSManagedObject, Insertable {

    // MARK: - Initializing
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName("DishIngredient", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }
}

// MARK: - CoreData Extension

extension DishIngredient {
    
    @NSManaged var multiplier: NSNumber
    @NSManaged var dish: Dish
    @NSManaged var ingredient: Ingredient
    
}
