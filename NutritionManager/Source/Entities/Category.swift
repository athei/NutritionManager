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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Category", in: context)!, insertInto: context)
    }
    
    // MARK: - Enums
    
    enum ValidationError: ErrorProtocol, CustomStringConvertible {
        case name
        
        var description: String  {
            switch (self) {
            case .name:
                return "Name must be between 1 and 50 characters"
            }
        }
    }
    
    // MARK: - Validation
    
    static func checkName(_ name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.name
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.name
        }
        return value
    }
    
    // MARK: - Static Helper
    
    static func nextOrderNumber() throws -> Int {
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        let sortDescriptor = SortDescriptor(key: "order", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        let categories =  try Database.get().moc.fetch(fetchRequest) 
        if (categories.count == 0) {
            return 0
        } else {
            return categories[0].order.intValue + 1
        }
    }

}

// MARK: - CoreData Extension

extension Category {
    
    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var ingredients: NSSet
    
}
