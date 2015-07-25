//
//  Category+CoreDataProperties.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 25.07.15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var ingredients: NSSet?

}
