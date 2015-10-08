//
//  DishIngredient.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 08.10.15.
//
//

import Foundation
import CoreData

class DishIngredient: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

// MARK: - CoreData Extension

extension DishIngredient {
    
    @NSManaged var multiplier: NSNumber
    @NSManaged var dish: Dish
    @NSManaged var ingredient: Ingredient
    
}
