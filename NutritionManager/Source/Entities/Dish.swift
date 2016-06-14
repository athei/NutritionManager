//
//  Dish.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 08.10.15.
//
//

import Foundation
import CoreData

class Dish: NSManagedObject, Insertable {
    
    // MARK: - Enums
    
    enum ValidationError: ErrorProtocol, CustomStringConvertible {
        enum NameValidationError {
            case invalid, notUnique
        }
        case name(NameValidationError)
        
        var description: String  {
            switch (self) {
            case .name(.invalid):
                return "Name must be between 1 and 100 characters"
            case .name(.notUnique):
                return "Name must be unique"
            }
        }
    }
    
    // MARK: - Properties
    
    var energy: NSNumber {
        var sum: Float = 0
        for dishIngredient in ingredients as! Set<DishIngredient> {
            sum += dishIngredient.multiplier.floatValue * dishIngredient.ingredient.energy.floatValue
        }
        return sum
    }
    
    var proteins: NSNumber {
        var sum: Float = 0
        for dishIngredient in ingredients as! Set<DishIngredient> {
            sum += dishIngredient.multiplier.floatValue * dishIngredient.ingredient.proteins.floatValue
        }
        return sum
    }
    
    var fat: NSNumber {
        var sum: Float = 0
        for dishIngredient in ingredients as! Set<DishIngredient> {
            sum += dishIngredient.multiplier.floatValue * dishIngredient.ingredient.fat.floatValue
        }
        return sum
    }
    
    var carbohydrates: NSNumber {
        var sum: Float = 0
        for dishIngredient in ingredients as! Set<DishIngredient> {
            sum += dishIngredient.multiplier.floatValue * dishIngredient.ingredient.carbohydrates.floatValue
        }
        return sum
    }

    // MARK: - Initializing
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Dish", in: context)!, insertInto: context)
    }
    
    // MARK: - Unit Conversion
    
    func formattedEnergy(withUnit: Bool, to: Units.Energy?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedEnergy(energyInKcal: energy, to: dest, withUnit: withUnit)
    }
    
    func formattedProteins(withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: proteins, to: dest, withUnit: withUnit)
    }
    
    func formattedFat(withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: fat, to: dest, withUnit: withUnit)
    }
    
    func formattedCarbohydrates(withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: carbohydrates, to: dest, withUnit: withUnit)
    }
    
    // MARK: - Validation
    
    static func checkName(_ name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.name(.invalid)
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.name(.invalid)
        }
        return value
    }


}

// MARK: - CoreData Extension

extension Dish {
    
    @NSManaged var name: String
    @NSManaged var directions: String
    @NSManaged var ingredients: NSSet
    @NSManaged var image: Data?
    
}

