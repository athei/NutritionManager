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

