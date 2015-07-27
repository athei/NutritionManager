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
class Ingredient: NSManagedObject {
    enum ValueScale: Int {
        case Mass = 0
        case Volume = 1
        case Unit = 2
    }
    
    enum ValidationError: ErrorType, CustomStringConvertible {
        enum NameValidationError {
            case Invalid, NotUnique
        }
        case Name(NameValidationError), Energy, ValueScale, Proteins, Fat, Carbohydrates
        
        var description: String  {
            switch (self) {
            case .Name(.Invalid):
                return "Name must be between 1 and 100 characters"
            case .Name(.NotUnique):
                return "Name must be unique"
            case .Energy:
                return "Energy must be an positive integer"
            case .ValueScale:
                return "Value scale out of range (this should not happen)"
            case .Proteins:
                return "Proteins must be a decimal number."
            case .Fat:
                return "Fat must be a decimal number."
            case .Carbohydrates:
                return "Carbohydrates must be a decimal number."
            }
        }
    }
    
    static let energyNumberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .NoStyle
        formatter.allowsFloats = false
        formatter.maximum = NSNumber(int: Int32.max)
        return formatter
    }()
    
    static let massNumberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.usesSignificantDigits = false
        formatter.maximumIntegerDigits = 100000
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    var valueScale: ValueScale {
        get {
            return ValueScale(rawValue: valueScale_.integerValue)!
        }
        set {
            valueScale_ = newValue.rawValue
        }
    }
    
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
    
    // MARK: Validation
    
    static func checkName(name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.Name(.Invalid)
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.Name(.Invalid)
        }
        return value
    }
    
    static func checkValueScale(valueScale: Int) throws -> ValueScale {
        guard let result = ValueScale(rawValue: valueScale) else {
            throw ValidationError.ValueScale
        }
        return result
    }
    
    static func checkEnergy(energy: String?) throws -> NSNumber {
        guard let value = energy else {
            throw ValidationError.Energy
        }
        guard let number = Ingredient.energyNumberFormatter.numberFromString(value) else {
            throw ValidationError.Energy
        }
        return number
    }
    
    static func checkProteins(mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.Proteins
        }
        guard let number = Ingredient.massNumberFormatter.numberFromString(value) else {
            throw ValidationError.Proteins
        }
        return number
    }
    
    static func checkFat(mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.Fat
        }
        guard let number = Ingredient.massNumberFormatter.numberFromString(value) else {
            throw ValidationError.Fat
        }
        return number
    }
    
    static func checkCarbohydrates(mass: String?) throws -> NSNumber {
        guard let value = mass else {
            throw ValidationError.Carbohydrates
        }
        guard let number = Ingredient.massNumberFormatter.numberFromString(value) else {
            throw ValidationError.Carbohydrates
        }
        return number
    }
    
}


extension Ingredient {
    
    @NSManaged var carbohydrates: NSNumber
    @NSManaged var energy: NSNumber
    @NSManaged var fat: NSNumber
    @NSManaged var name: String
    @NSManaged var proteins: NSNumber
    @NSManaged private var valueScale_: NSNumber
    @NSManaged var category: Category
    
}
