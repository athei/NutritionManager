//
//  NutritionValueFormatter.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import Foundation


private let massProcessors  = [Units.Mass.Gram: GramProcessor()]
private let energyProcesors = [Units.Energy.Kcal: KcalProcessor()]

// MARK: Units Utility class

class Units {
    enum Mass: Int {
        case Gram
    }
    enum Energy: Int {
        case Kcal
    }
    
    static func formattedMass(massInGram mass: NSDecimalNumber, to: Mass, withUnit: Bool) -> String {
        return massProcessors[to]!.formattedMass(massInGram: mass, withUnit: withUnit)
    }
    
    static func normalizedMass(mass: NSDecimalNumber, from: Mass) -> NSDecimalNumber {
        return massProcessors[from]!.normalizedMass(mass)
    }
    
    static func formattedEnergy(energyInKcal energy: NSDecimalNumber, to: Energy, withUnit: Bool) -> String {
        return energyProcesors[to]!.formattedEnergy(energyInKcal: energy, withUnit: withUnit)
    }
    
    static func normalizedEnergy(energy: NSDecimalNumber, from: Energy) -> NSDecimalNumber {
        return energyProcesors[from]!.normalizedEnergy(energy)
    }
    
    static func choosenUnitOrDefault(choosenUnit: Units.Mass?) -> Units.Mass {
        var dest = choosenUnit
        if (dest == nil) {
            dest = Units.Mass.Gram
        }
        return dest!
    }
    
    static func choosenUnitOrDefault(choosenUnit: Units.Energy?) -> Units.Energy {
        var dest = choosenUnit
        if (dest == nil) {
            dest = Units.Energy.Kcal
        }
        return dest!
    }
}


// MARK: Private Implementation of the unit system


private protocol MassProcessor {
    func formattedMass(massInGram mass: NSDecimalNumber, withUnit: Bool) -> String
    func normalizedMass(mass: NSDecimalNumber) -> NSDecimalNumber
}

private protocol EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSDecimalNumber, withUnit: Bool) -> String
    func normalizedEnergy(energy: NSDecimalNumber) -> NSDecimalNumber
}


private class GramProcessor: MassProcessor {
    func formattedMass(massInGram mass: NSDecimalNumber, withUnit: Bool) -> String {
        if (withUnit) {
            return "\(mass) g"
        } else {
            return "\(mass)"
        }
    }
    func normalizedMass(mass: NSDecimalNumber) -> NSDecimalNumber {
        return mass
    }
}

private class KcalProcessor: EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSDecimalNumber, withUnit: Bool) -> String {
        if (withUnit) {
            return "\(energy) kcal"
        } else {
            return "\(energy)"
        }
    }
    func normalizedEnergy(energy: NSDecimalNumber) -> NSDecimalNumber {
        return energy
    }
}

