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
