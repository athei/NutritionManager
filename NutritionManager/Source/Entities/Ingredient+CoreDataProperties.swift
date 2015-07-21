//
//  Ingredient+CoreDataProperties.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 21.07.15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Ingredient {

    @NSManaged var carbohydrates: NSNumber?
    @NSManaged var category: NSNumber?
    @NSManaged var energy: NSNumber?
    @NSManaged var fat: NSNumber?
    @NSManaged var name: String?
    @NSManaged var proteins: NSNumber?

}
