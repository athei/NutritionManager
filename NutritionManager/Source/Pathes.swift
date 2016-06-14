//
//  Pathes.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 21.07.15.
//
//

import Foundation

class Pathes {
    static func documentURL() -> URL {
        return FileManager.default().urlsForDirectory(FileManager.SearchPathDirectory.libraryDirectory, inDomains: FileManager.SearchPathDomainMask.userDomainMask)[0]
    }
    
    static func databaseURL() -> URL {
        return try! documentURL().appendingPathComponent("database.sqlite")
    }
    
    static func modelURL() -> URL? {
        return Bundle.main().urlForResource("model", withExtension: "momd")
    }
}
