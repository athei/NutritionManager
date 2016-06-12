//
//  CategoryList.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 29.09.15.
//
//

import UIKit
import CoreData

class CategoryList: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    weak var delegate: CategoryListProtocol?
    
    // MARK: - Private variables
    private let fetchedResultsController: NSFetchedResultsController
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    // MARK: - Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(CategoryList.newCategory(_:)))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func newCategory(sender: UIButton) {
        presentCategoryNameInputAlert("New Category", message: nil, modifyCategory: nil, withInputHandler: categoryAlertDidSave)
    }
    
    func categoryAlertDidSave(fieldValue: String?, editedCategory: Category?) {
        do {
            let name = try Category.checkName(fieldValue)
            
            if let category = editedCategory { // an existing category is edited
                category.name = name
                try! Database.get().moc.save()
                delegate?.categoryList(self, didChangeCategory: category)
            } else {
                let newCategory = Category(context: Database.get().moc)
                newCategory.name = name
                newCategory.order = try! Category.nextOrderNumber()
                try! Database.get().moc.save()
            }
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Category", forIndexPath: indexPath)
        let category = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        cell.textLabel!.text = category.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.categoryList(self, didSelectCategory: fetchedResultsController.objectAtIndexPath(indexPath) as! Category)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let category = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        presentCategoryNameInputAlert("Edit Category", message: nil, modifyCategory: category, withInputHandler: categoryAlertDidSave)
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let category = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        if (category.ingredients.count > 0) {
            return .None
        } else {
            return .Delete
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let category = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
            Database.get().moc.deleteObject(category)
            try! Database.get().moc.save()
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // let a array do the index calculations for the reordering
        var categories = fetchedResultsController.fetchedObjects as! [Category]
        let category = fetchedResultsController.objectAtIndexPath(fromIndexPath) as! Category
        categories.removeAtIndex(fromIndexPath.row)
        categories.insert(category, atIndex: toIndexPath.row)
        
        // save the calculated indizes to coredata
        // we need to deactivate change tracking (the ui handles the changes itself)
        fetchedResultsController.delegate = nil
        var i = 0
        for cat in categories {
            cat.order = i
            i += 1
        }
        try! Database.get().moc.save()
        fetchedResultsController.delegate = self
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
    
    
    // MARK: - Private helper
    
    private func presentCategoryNameInputAlert(title: String?, message: String?, modifyCategory category: Category?, withInputHandler handler: (String?, Category?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okayButton = UIAlertAction(title: "Save", style: .Default) { (UIAlertAction) -> Void in
            handler(alert.textFields![0].text, category)
        }
        alert.addAction(cancelButton)
        alert.addAction(okayButton)
        alert.preferredAction = okayButton
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Enter name of the Category"
            if let category = category {
                textField.text = category.name
            }
        }
        presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - Protocols

protocol CategoryListProtocol: class {
    func categoryList(categoryList: CategoryList, didSelectCategory category: Category)
    func categoryList(categoryList: CategoryList, didChangeCategory category: Category)
    
}
