//
//  Ingredient+CoreDataProperties.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Ingredient {

    @NSManaged var carbohydrates: NSDecimalNumber
    @NSManaged var category: NSDecimalNumber
    @NSManaged var energy: NSDecimalNumber
    @NSManaged var fat: NSDecimalNumber
    @NSManaged var name: String
    @NSManaged var proteins: NSDecimalNumber

}
