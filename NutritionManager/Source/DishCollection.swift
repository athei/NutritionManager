//
//  DishCollection.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 11.10.15.
//
//

import UIKit
import CoreData

class DishCollection: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - Private variables
    
    private let fetchedResultsController: NSFetchedResultsController<Dish>
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest<Dish>(entityName: "Dish")
        let sortDescriptor = SortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        adjustCellsToViewSize(view.bounds.size)
    }
    
    // MARK: - View lifecycle
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustCellsToViewSize(size)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        return !isEditing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "dishDetail") {
            let dishDetail = segue.destinationViewController as! DishCollectionProtocol
            let dish = fetchedResultsController.object(at: collectionView!.indexPathsForSelectedItems()![0]) 
            dishDetail.dishSelected(dish)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dishLongTap(_ sender: UILongPressGestureRecognizer) {
        if (presentedViewController != nil) {
            return
        }
        
        let dish = (sender.view as! DishCell).dish!
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) -> Void in
            Database.get().moc.delete(dish)
            try! Database.get().moc.save()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let sheet = UIAlertController(title: dish.name, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(deleteButton)
        sheet.addAction(cancelButton)
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dish", for: indexPath) as! DishCell
        let dish = fetchedResultsController.object(at: indexPath) 
        
        cell.dish = dish
        if (cell.contextMenuGestureRecognizer == nil) {
            cell.contextMenuGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DishCollection.dishLongTap(_:)))
        }
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .move:
            collectionView?.performBatchUpdates({ () -> Void in
                self.collectionView?.deleteItems(at: [indexPath!])
                self.collectionView?.insertItems(at: [newIndexPath!])
                }, completion: nil)
            break
        case .delete:
            collectionView?.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView?.reloadItems(at: [indexPath!])
            break
        case .insert:
            collectionView?.insertItems(at: [indexPath!])
            break
        }
    }
    
    // MARK: - Private helpers
    
    private func adjustCellsToViewSize(_ size: CGSize) {
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellSize =  size.width / 3
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Protocols

protocol DishCollectionProtocol: class {
    func dishSelected(_ dish: Dish)
}
