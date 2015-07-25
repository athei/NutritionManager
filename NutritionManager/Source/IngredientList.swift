//
//  FirstViewController.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 20.07.15.
//
//

import UIKit
import CoreData

protocol IngredientDetailViewProtocol: class {
    func ingredientSelected(ingredient: Ingredient)
}

class IngredientList: UITableViewController {
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ingredientDetail") {
            let destination = (segue.destinationViewController as! UINavigationController).viewControllers.first as! IngredientDetailViewProtocol
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
}

// MARK: UISplitViewControllerDelegate Implementation

extension IngredientList: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return tableView.indexPathForSelectedRow == nil
    }
    
    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        return false
    }
}

// MARK: NSFetchedResultsControllerDelegate Implementation

extension IngredientList: NSFetchedResultsControllerDelegate {
    
}
