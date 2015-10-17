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
    
    enum ValidationError: ErrorType, CustomStringConvertible {
        enum NameValidationError {
            case Invalid, NotUnique
        }
        case Name(NameValidationError)
        
        var description: String  {
            switch (self) {
            case .Name(.Invalid):
                return "Name must be between 1 and 100 characters"
            case .Name(.NotUnique):
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
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName("Dish", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Unit Conversion
    
    func formattedEnergy(withUnit withUnit: Bool, to: Units.Energy?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedEnergy(energyInKcal: energy, to: dest, withUnit: withUnit)
    }
    
    func formattedProteins(withUnit withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: proteins, to: dest, withUnit: withUnit)
    }
    
    func formattedFat(withUnit withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: fat, to: dest, withUnit: withUnit)
    }
    
    func formattedCarbohydrates(withUnit withUnit: Bool, to: Units.Mass?) -> String {
        let dest = Units.choosenUnitOrDefault(to)
        return Units.formattedMass(massInGram: carbohydrates, to: dest, withUnit: withUnit)
    }
    
    // MARK: - Validation
    
    static func checkName(name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.Name(.Invalid)
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.Name(.Invalid)
        }
        return value
    }


}

// MARK: - CoreData Extension

extension Dish {
    
    @NSManaged var name: String
    @NSManaged var directions: String
    @NSManaged var ingredients: NSSet
    @NSManaged var image: NSData?
    
}

