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
    
    enum ValidationError: ErrorType {
        enum NameValidationError {
            case Invalid, NotUnique
        }
        case Name(NameValidationError), Energy, ValueScale, Proteins, Fat, Carbohydrates
        
        func description() -> String {
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
    
    func checkName(name: String?) throws -> String {
        guard let value = name else {
            throw ValidationError.Name(.Invalid)
        }
        guard 1...100 ~= value.characters.count else {
            throw ValidationError.Name(.Invalid)
        }
        return value
    }
}


extension Ingredient {
    
    @NSManaged var carbohydrates: NSDecimalNumber
    @NSManaged var energy: NSDecimalNumber
    @NSManaged var fat: NSDecimalNumber
    @NSManaged var name: String
    @NSManaged var proteins: NSDecimalNumber
    @NSManaged private var valueScale_: NSNumber
    @NSManaged var category: Category
    
}
