//
//  FirstViewController.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 20.07.15.
//
//

import UIKit
import CoreData

protocol IngredientListProtocol: class {
    func ingredientSelected(ingredient: Ingredient)
}

class IngredientList: UITableViewController, UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    private let fetchedResultsController: NSFetchedResultsController
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: "IngredientsList")
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        splitViewController?.delegate = self;
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ingredientDetail") {
            let navi = segue.destinationViewController as! UINavigationController
            let destination = navi.viewControllers.first as! IngredientListProtocol
            let ingredient = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Ingredient
            destination.ingredientSelected(ingredient)
        }
    }
    
    // MARK: UITableViewDataSource Implementation
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) as! IngredientCell
        let ingredient = fetchedResultsController.objectAtIndexPath(indexPath) as! Ingredient
        cell.ingredientName.text = ingredient.name
        cell.ingredientEnergy.text = ingredient.formattedEnergy(withUnit: true, to: nil)
        cell.ingredientProteins.text = "\(ingredient.formattedProteins(withUnit: true, to: nil)) prot"
        cell.ingredientFat.text = "\(ingredient.formattedFat(withUnit: true, to: nil)) fat"
        cell.ingredientCarbohydrates.text = "\(ingredient.formattedCarbohydrates(withUnit: true, to: nil)) carb"
        
        return cell;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    // MARK: NSFetchedResultsControllerDelegate Implementation
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        default:
            break
        }
    }
    
    
    // MARK: UISplitViewControllerDelegate Implementation
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return tableView.indexPathForSelectedRow == nil
    }
}
