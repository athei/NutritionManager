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
    private let fetchedResultsController: NSFetchedResultsController<Category>
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        let sortDescriptor = SortDescriptor(key: "order", ascending: true)
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(CategoryList.newCategory(_:)))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func newCategory(_ sender: UIButton) {
        presentCategoryNameInputAlert("New Category", message: nil, modifyCategory: nil, withInputHandler: categoryAlertDidSave)
    }
    
    func categoryAlertDidSave(_ fieldValue: String?, editedCategory: Category?) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let category = fetchedResultsController.object(at: indexPath) 
        cell.textLabel!.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categoryList(self, didSelectCategory: fetchedResultsController.object(at: indexPath))
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath) 
        presentCategoryNameInputAlert("Edit Category", message: nil, modifyCategory: category, withInputHandler: categoryAlertDidSave)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let category = fetchedResultsController.object(at: indexPath) 
        if (category.ingredients.count > 0) {
            return .none
        } else {
            return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = fetchedResultsController.object(at: indexPath) 
            Database.get().moc.delete(category)
            try! Database.get().moc.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        // let a array do the index calculations for the reordering
        var categories = fetchedResultsController.fetchedObjects!
        let category = fetchedResultsController.object(at: fromIndexPath)
        categories.remove(at: (fromIndexPath as NSIndexPath).row)
        categories.insert(category, at: (toIndexPath as NSIndexPath).row)
        
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
    
    
    // MARK: - Private helper
    
    private func presentCategoryNameInputAlert(_ title: String?, message: String?, modifyCategory category: Category?, withInputHandler handler: (String?, Category?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okayButton = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) -> Void in
            handler(alert.textFields![0].text, category)
        }
        alert.addAction(cancelButton)
        alert.addAction(okayButton)
        alert.preferredAction = okayButton
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "Enter name of the Category"
            if let category = category {
                textField.text = category.name
            }
        }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Protocols

protocol CategoryListProtocol: class {
    func categoryList(_ categoryList: CategoryList, didSelectCategory category: Category)
    func categoryList(_ categoryList: CategoryList, didChangeCategory category: Category)
    
}
