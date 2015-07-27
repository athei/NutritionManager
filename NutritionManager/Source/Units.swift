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
    
    static func formattedMass(massInGram mass: NSNumber, to: Mass, withUnit: Bool) -> String {
        return massProcessors[to]!.formattedMass(massInGram: mass, withUnit: withUnit)
    }
    
    static func normalizedMass(mass: NSNumber, from: Mass) -> NSNumber {
        return massProcessors[from]!.normalizedMass(mass)
    }
    
    static func formattedEnergy(energyInKcal energy: NSNumber, to: Energy, withUnit: Bool) -> String {
        return energyProcesors[to]!.formattedEnergy(energyInKcal: energy, withUnit: withUnit)
    }
    
    static func normalizedEnergy(energy: NSNumber, from: Energy) -> NSNumber {
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
    func formattedMass(massInGram mass: NSNumber, withUnit: Bool) -> String
    func normalizedMass(mass: NSNumber) -> NSNumber
}

private protocol EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSNumber, withUnit: Bool) -> String
    func normalizedEnergy(energy: NSNumber) -> NSNumber
}


private class GramProcessor: MassProcessor {
    func formattedMass(massInGram mass: NSNumber, withUnit: Bool) -> String {
        if (withUnit) {
            return "\(mass) g"
        } else {
            return "\(mass)"
        }
    }
    func normalizedMass(mass: NSNumber) -> NSNumber {
        return mass
    }
}

private class KcalProcessor: EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSNumber, withUnit: Bool) -> String {
        if (withUnit) {
            return "\(energy) kcal"
        } else {
            return "\(energy)"
        }
    }
    func normalizedEnergy(energy: NSNumber) -> NSNumber {
        return energy
    }
}

