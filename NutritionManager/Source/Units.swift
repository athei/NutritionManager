//
//  NutritionValueFormatter.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import Foundation


private let massProcessors  = [Units.Mass.gram: GramProcessor()]
private let energyProcesors = [Units.Energy.kcal: KcalProcessor()]

// MARK: Units Utility class

class Units {
    private static let energyNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        formatter.allowsFloats = false
        formatter.maximum = NSNumber(value: Int32.max)
        return formatter
        }()
    
    private static let massNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.usesSignificantDigits = false
        formatter.maximum = 1000000
        formatter.maximumFractionDigits = 1
        return formatter
        }()
    
    enum Mass: Int {
        case gram
    }
    enum Energy: Int {
        case kcal
    }
    
    static func formattedMass(massInGram mass: NSNumber, to: Mass, withUnit: Bool) -> String {
        return massProcessors[to]!.formattedMass(massInGram: mass, withUnit: withUnit)
    }
    
    static func normalizedMass(_ mass: NSNumber, from: Mass) -> NSNumber {
        return massProcessors[from]!.normalizedMass(mass)
    }
    
    static func formattedEnergy(energyInKcal energy: NSNumber, to: Energy, withUnit: Bool) -> String {
        return energyProcesors[to]!.formattedEnergy(energyInKcal: energy, withUnit: withUnit)
    }
    
    static func normalizedEnergy(_ energy: NSNumber, from: Energy) -> NSNumber {
        return energyProcesors[from]!.normalizedEnergy(energy)
    }
    
    static func validateInputEnergy(_ input: String) -> NSNumber? {
        return energyNumberFormatter.number(from: input)
    }
    
    static func validateInputMass(_ input: String) -> NSNumber? {
        return massNumberFormatter.number(from: input)
    }
    
    static func choosenUnitOrDefault(_ choosenUnit: Units.Mass?) -> Units.Mass {
        var dest = choosenUnit
        if (dest == nil) {
            dest = Units.Mass.gram
        }
        return dest!
    }
    
    static func choosenUnitOrDefault(_ choosenUnit: Units.Energy?) -> Units.Energy {
        var dest = choosenUnit
        if (dest == nil) {
            dest = Units.Energy.kcal
        }
        return dest!
    }
}


// MARK: - Private Implementation of the unit system


private protocol MassProcessor {
    func formattedMass(massInGram mass: NSNumber, withUnit: Bool) -> String
    func normalizedMass(_ mass: NSNumber) -> NSNumber
}

extension MassProcessor {
    func formattedNumber(_ number: NSNumber) -> String {
        return Units.massNumberFormatter.string(from: number)!
    }
}

private protocol EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSNumber, withUnit: Bool) -> String
    func normalizedEnergy(_ energy: NSNumber) -> NSNumber
}

extension EnergyProcessor {
    func formattedNumber(_ number: NSNumber) -> String {
        return Units.energyNumberFormatter.string(from: number)!
    }
}


private class GramProcessor: MassProcessor {
    func formattedMass(massInGram mass: NSNumber, withUnit: Bool) -> String {
        let number = formattedNumber(mass)
        if (withUnit) {
            return "\(number) g"
        } else {
            return "\(number)"
        }
    }
    func normalizedMass(_ mass: NSNumber) -> NSNumber {
        return mass
    }
}

private class KcalProcessor: EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSNumber, withUnit: Bool) -> String {
        let number = formattedNumber(energy)
        if (withUnit) {
            return "\(number) kcal"
        } else {
            return "\(number)"
        }
    }
    func normalizedEnergy(_ energy: NSNumber) -> NSNumber {
        return energy
    }
}

