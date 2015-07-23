//
//  FirstViewController.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 20.07.15.
//
//

import UIKit
import CoreData

class IngredientList: UITableViewController, NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate {
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) as! IngredientCell
        let ingredient = fetchedResultsController.objectAtIndexPath(indexPath) as! Ingredient
        cell.ingredientName.text = ingredient.name
        cell.ingredientEnergy.text = "\(ingredient.energy) kcal"
        cell.ingredientProteins.text = "\(ingredient.proteins)g prot"
        cell.ingredientFat.text = "\(ingredient.fat)g fat"
        cell.ingredientCarbohydrates.text = "\(ingredient.carbohydrates)g carb"
        
        return cell;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return tableView.indexPathForSelectedRow == nil
    }


}

