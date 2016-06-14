//
//  Ingredient.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 22.07.15.
//
//

import Foundation
import CoreData

@objc(Ingredient)
class Ingredient: NSManagedObject, Insertable {
    
    // MARK: - Initializing
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Ingredient", in: context)!, insertInto: context)
    }
    
    // MARK: - Enums
    enum ValueScale: Int {
        case mass = 0
        case volume = 1
        case unit = 2
    }
    
    enum ValidationError: ErrorProtocol, CustomStringConvertible {
        enum NameValidationError {
            case invalid, notUnique
        }
        case name(NameValidationError), energy, valueScale, proteins, fat, carbohydrates, category
        
        var description: String  {
            switch (self) {
            case .name(.invalid):
                return "Name must be between 1 and 100 characters"
            case .name(.notUnique):
                return "Name must be unique"
            case .energy:
                return "Energy must be an positive integer"
            case .valueScale:
                return "Value scale out of range (this should not happen)"
            case .proteins:
                return "Proteins must be a decimal number."
            case .fat:
                return "Fat must be a decimal number."
            case .carbohydrates:
                return "Carbohydrates must be a decimal number."
            case .category:
                return "You must select a category."
            }
        }
    }
    
    // MARK: - Unit Conversion
    
    var valueScale: ValueScale {
        get {
            return ValueScale(rawValue: valueScale_.intValue)!
        }
        set {
            valueScale_ = newValue.rawValue
        }
    }
    
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
    
    static func checkValueScale(_ valueScale: Int) throws -> ValueScale {
        guard let result = ValueScale(rawValue: valueScale) else {
            throw ValidationError.valueScale
        }
        return result
    }
    
    static func checkEnergy(_ energy: String?) throws -> NSNumber {
        guard let value = energy else {
            throw ValidationError.energy
        }
        guard let number = Units.validateInputEnergy(value) else {
            throw ValidationError.energy
        }
        return number
    }
    
    static func checkProteins(_ mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.proteins
        }
        guard let number = Units.validateInputMass(value) else {
            throw ValidationError.proteins
        }
        return number
    }
    
    static func checkFat(_ mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.fat
        }
        guard let number = Units.validateInputMass(value) else {
            throw ValidationError.fat
        }
        return number
    }
    
    static func checkCarbohydrates(_ mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.carbohydrates
        }
        guard let number = Units.validateInputMass(value) else {
            throw ValidationError.carbohydrates
        }
        return number
    }
    
    static func checkCategory(_ category: Category?) throws -> Category {
        guard let cat = category else {
            throw ValidationError.category
        }
        return cat
    }
    
}

// MARK: - CoreData Extension


extension Ingredient {
    
    @NSManaged var carbohydrates: NSNumber
    @NSManaged var energy: NSNumber
    @NSManaged var fat: NSNumber
    @NSManaged var name: String
    @NSManaged var proteins: NSNumber
    @NSManaged private var valueScale_: NSNumber
    @NSManaged var category: Category
    @NSManaged var dishes: NSSet
    @NSManaged var image: Data?
    
}
