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
    private static let energyNumberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .NoStyle
        formatter.usesGroupingSeparator = false
        formatter.allowsFloats = false
        formatter.maximum = NSNumber(int: Int32.max)
        return formatter
        }()
    
    private static let massNumberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.usesGroupingSeparator = false
        formatter.usesSignificantDigits = false
        formatter.maximum = 1000000
        formatter.maximumFractionDigits = 1
        return formatter
        }()
    
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
    
    static func validateInputEnergy(input: String) -> NSNumber? {
        return energyNumberFormatter.numberFromString(input)
    }
    
    static func validateInputMass(input: String) -> NSNumber? {
        return massNumberFormatter.numberFromString(input)
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

extension MassProcessor {
    func formattedNumber(number: NSNumber) -> String {
        return Units.massNumberFormatter.stringFromNumber(number)!
    }
}

private protocol EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSNumber, withUnit: Bool) -> String
    func normalizedEnergy(energy: NSNumber) -> NSNumber
}

extension EnergyProcessor {
    func formattedNumber(number: NSNumber) -> String {
        return Units.energyNumberFormatter.stringFromNumber(number)!
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
    func normalizedMass(mass: NSNumber) -> NSNumber {
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
    func normalizedEnergy(energy: NSNumber) -> NSNumber {
        return energy
    }
}

