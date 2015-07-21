//
//  AppDelegate.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 20.07.15.
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.LibraryDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if let modelFile = NSBundle.mainBundle().URLForResource("model", withExtension: "momd") {
            if let model = NSManagedObjectModel(contentsOfURL: modelFile) {
                let coord = NSPersistentStoreCoordinator(managedObjectModel:model)
                //NSPersistentStore(persistentStoreCoordinator: coord, configurationName: nil, URL: NSFileManager.defaultManager().URLForDirectory(<#T##directory: NSSearchPathDirectory##NSSearchPathDirectory#>, inDomain: <#T##NSSearchPathDomainMask#>, appropriateForURL: <#T##NSURL?#>, create: <#T##Bool#>), options: <#T##[NSObject : AnyObject]?#>)
                //try! coord.addPersistentStoreWithType("SQL", configuration: nil, URL: nil, options: nil)
                let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                context.persistentStoreCoordinator = coord
                let _ = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: context)
                try! context.save();
            }
        }
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

