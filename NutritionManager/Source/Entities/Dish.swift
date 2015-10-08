//
//  Dish.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 08.10.15.
//
//

import Foundation
import CoreData

class Dish: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

// MARK: - CoreData Extension

extension Dish {
    
    @NSManaged var name: String
    @NSManaged var directions: String
    @NSManaged var ingredients: NSSet
    
}

