//
//  DishCollection.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 11.10.15.
//
//

import UIKit
import CoreData

class DishCollection: UICollectionViewController {
    // MARK: - Private variables
    private let fetchedResultsController: NSFetchedResultsController
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        let fetchRequest = NSFetchRequest(entityName: "Dish")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.get().moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()

        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "dishDetail") {
            let dishDetail = segue.destinationViewController as! DishCollectionProtocol
            let dish = fetchedResultsController.objectAtIndexPath(collectionView!.indexPathsForSelectedItems()![0]) as! Dish
            dishDetail.dishSelected(dish)
        }
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
        
        cell.dishName.text = dish.name
        if let imgData = dish.image {
            cell.dishImage.image = UIImage(data: imgData)
        } else {
            cell.dishImage.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
}

// MARK: - Protocols

protocol DishCollectionProtocol: class {
    func dishSelected(dish: Dish)
}
