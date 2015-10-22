//
//  DishCollection.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 11.10.15.
//
//

import UIKit
import CoreData

class DishCollection: UICollectionViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Private variables
    private let fetchedResultsController: NSFetchedResultsController
    private var contextMenuPresenting = false
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest(entityName: "Dish")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !editing
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "dishDetail") {
            let dishDetail = segue.destinationViewController as! DishCollectionProtocol
            let dish = fetchedResultsController.objectAtIndexPath(collectionView!.indexPathsForSelectedItems()![0]) as! Dish
            dishDetail.dishSelected(dish)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dishLongTap(sender: UILongPressGestureRecognizer) {
        if (presentedViewController != nil) {
            return
        }
        
        let dish = (sender.view as! DishCell).dish!
        
        let deleteButton = UIAlertAction(title: "Delete", style: .Destructive) { (UIAlertAction) -> Void in
            Database.get().moc.deleteObject(dish)
            try! Database.get().moc.save()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let sheet = UIAlertController(title: dish.name, message: nil, preferredStyle: .ActionSheet)
        sheet.addAction(deleteButton)
        sheet.addAction(cancelButton)
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dish", forIndexPath: indexPath) as! DishCell
        let dish = fetchedResultsController.objectAtIndexPath(indexPath) as! Dish
        
        cell.dish = dish
        if (cell.contextMenuGestureRecognizer == nil) {
            cell.contextMenuGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "dishLongTap:")
        }
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Move:
            collectionView?.performBatchUpdates({ () -> Void in
                self.collectionView?.deleteItemsAtIndexPaths([indexPath!])
                self.collectionView?.insertItemsAtIndexPaths([newIndexPath!])
                }, completion: nil)
            break
        case .Delete:
            collectionView?.deleteItemsAtIndexPaths([indexPath!])
            break
        case .Update:
            collectionView?.reloadItemsAtIndexPaths([indexPath!])
            break
        case .Insert:
            collectionView?.insertItemsAtIndexPaths([indexPath!])
            break
        }
    }
}

// MARK: - Protocols

protocol DishCollectionProtocol: class {
    func dishSelected(dish: Dish)
}
