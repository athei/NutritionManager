//
//  Pathes.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 21.07.15.
//
//

import Foundation

class Pathes {
    static func documentURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.LibraryDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0]
    }
    
    static func databaseURL() -> NSURL {
        return documentURL().URLByAppendingPathComponent("database.sqlite")
    }
    
    static func modelURL() -> NSURL? {
        return NSBundle.mainBundle().URLForResource("model", withExtension: "momd")
    }
}