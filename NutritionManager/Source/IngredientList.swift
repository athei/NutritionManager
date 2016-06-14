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
    // MARK: - Private variables
    private let fetchedResultsController: NSFetchedResultsController<Ingredient>
    
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let sortDescriptor = SortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        splitViewController?.delegate = self;
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ingredientDetail") {
            let navi = segue.destinationViewController as! UINavigationController
            let destination = navi.viewControllers.first as! IngredientListProtocol
            let ingredient = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!) 
            destination.ingredientSelected(ingredient)
        }
    }
    
    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath) as! IngredientCell
        let ingredient = fetchedResultsController.object(at: indexPath) 
        cell.ingredientName.text = ingredient.name
        cell.ingredientEnergy.text = ingredient.formattedEnergy(withUnit: true, to: nil)
        if let imgData = ingredient.image {
            cell.ingredientImage.image = UIImage(data: imgData)
        } else {
            cell.ingredientImage.image = UIImage(named: "placeholder")
        }
        
        return cell;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let ingredient = fetchedResultsController.object(at: indexPath) 
        
        if (ingredient.dishes.count > 0) {
            return .none
        } else {
           return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ingredient = fetchedResultsController.object(at: indexPath) 
            Database.get().moc.delete(ingredient)
            try! Database.get().moc.save()
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .move:
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            tableView.endUpdates()
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            break
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            break
        }
    }
    
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return tableView.indexPathForSelectedRow == nil
    }
}

// MARK: - Protocols

protocol IngredientListProtocol: class {
    func ingredientSelected(_ ingredient: Ingredient)
}
