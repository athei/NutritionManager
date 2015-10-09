//
//  Insertable.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 09.10.15.
//
//

import Foundation
import CoreData

protocol Insertable {
    init(context: NSManagedObjectContext)
}