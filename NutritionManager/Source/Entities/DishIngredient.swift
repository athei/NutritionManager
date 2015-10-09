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
    
    required init(context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entityForName("DishIngredient", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }
}

// MARK: - CoreData Extension

extension DishIngredient {
    
    @NSManaged var multiplier: NSNumber
    @NSManaged var dish: Dish
    @NSManaged var ingredient: Ingredient
    
}
