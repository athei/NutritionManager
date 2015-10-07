//
//  FirstViewController.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 20.07.15.
//
//

import UIKit
import CoreData

class IngredientList: UITableViewController, UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    private let fetchedResultsController: NSFetchedResultsController
    
    // MARK: - Controller Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest(entityName: "Ingredient")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        splitViewController?.delegate = self;
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ingredientDetail") {
            let navi = segue.destinationViewController as! UINavigationController
            let destination = navi.viewControllers.first as! IngredientListProtocol
            let ingredient = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Ingredient
            destination.ingredientSelected(ingredient)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) as! IngredientCell
        let ingredient = fetchedResultsController.objectAtIndexPath(indexPath) as! Ingredient
        cell.ingredientName.text = ingredient.name
        cell.ingredientEnergy.text = ingredient.formattedEnergy(withUnit: true, to: nil)
        
        return cell;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete // TODO: only allow when not in use by dish
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Move:
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            tableView.endUpdates()
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
        }
    }
    
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return tableView.indexPathForSelectedRow == nil
    }
}

// MARK: - Protocols

protocol IngredientListProtocol: class {
    func ingredientSelected(ingredient: Ingredient)
}
