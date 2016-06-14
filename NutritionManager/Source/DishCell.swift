//
//  DishCell.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 11.10.15.
//
//

import UIKit

class DishCell: UICollectionViewCell {
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    
    var contextMenuGestureRecognizer: UILongPressGestureRecognizer? {
        didSet {
            if let oldRecognizer = oldValue {
                removeGestureRecognizer(oldRecognizer)
            }
            if let newRecognizer = contextMenuGestureRecognizer {
                addGestureRecognizer(newRecognizer)
            }
        }
    }
    
    var dish: Dish? {
        didSet {
            if let newDish = dish {
                dishName.text = newDish.name
                if let imgData = newDish.image {
                    dishImage.image = UIImage(data: imgData as Data)
                } else {
                    dishImage.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}
