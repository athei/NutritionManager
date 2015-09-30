//
//  Category.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 25.07.15.
//
//

import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

// MARK: - CoreData Extension

extension Category {
    
    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var ingredients: NSSet?
    
}