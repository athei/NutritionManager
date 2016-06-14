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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "DishIngredient", in: context)!, insertInto: context)
    }
}

// MARK: - CoreData Extension

extension DishIngredient {
    
    @NSManaged var multiplier: NSNumber
    @NSManaged var dish: Dish
    @NSManaged var ingredient: Ingredient
    
}
