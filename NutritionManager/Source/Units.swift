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


class Units {
    enum Mass: Int {
        case Gram
    }
    enum Energy: Int {
        case Kcal
    }
    
    static func formattedMass(massInGram mass: NSDecimalNumber, to: Mass) -> String {
        return massProcessors[to]!.formattedMass(massInGram: mass)
    }
    
    static func normalizedMass(mass: NSDecimalNumber, from: Mass) -> NSDecimalNumber {
        return massProcessors[from]!.normalizedMass(mass)
    }
    
    static func formattedEnergy(energyInKcal energy: NSDecimalNumber, to: Energy) -> String {
        return energyProcesors[to]!.formattedEnergy(energyInKcal: energy)
    }
    
    static func normalizedEnergy(energy: NSDecimalNumber, from: Energy) -> NSDecimalNumber {
        return energyProcesors[from]!.normalizedEnergy(energy)
    }
}




private protocol MassProcessor {
    func formattedMass(massInGram mass: NSDecimalNumber) -> String
    func normalizedMass(value: NSDecimalNumber) -> NSDecimalNumber
}

private protocol EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSDecimalNumber) -> String
    func normalizedEnergy(energy: NSDecimalNumber) -> NSDecimalNumber
}



private class GramProcessor: MassProcessor {
    func formattedMass(massInGram mass: NSDecimalNumber) -> String {
        return "\(mass) g"
    }
    func normalizedMass(value: NSDecimalNumber) -> NSDecimalNumber {
        return value
    }
}

private class KcalProcessor: EnergyProcessor {
    func formattedEnergy(energyInKcal energy: NSDecimalNumber) -> String {
        return "\(energy) kcal"
    }
    func normalizedEnergy(energy: NSDecimalNumber) -> NSDecimalNumber {
        return energy
    }
}

