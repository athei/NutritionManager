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
class Category: NSManagedObject, Insertable {
    
    // MARK: - Initializing
    
    required init(context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entityForName("Category", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Enums
    
    enum ValidationError: ErrorType, CustomStringConvertible {
        case Name
        
        var description: String  {
            switch (self) {
            case .Name:
                return "Name must be between 1 and 50 characters"
            }
        }
    }
    
    // MARK: - Validation
    
    static func checkName(name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.Name
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.Name
        }
        return value
    }
    
    // MARK: - Static Helper
    
    static func nextOrderNumber() throws -> Int {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        let categories =  try Database.get().moc.executeFetchRequest(fetchRequest) as! [Category]
        if (categories.count == 0) {
            return 0
        } else {
            return categories[0].order.integerValue + 1
        }
    }

}

// MARK: - CoreData Extension

extension Category {
    
    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var ingredients: NSSet
    
}