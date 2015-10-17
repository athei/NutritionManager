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
    
    override var selected: Bool {
        didSet {
            if (selected) {
                backgroundColor = UIColor.blueColor()
            } else {
                backgroundColor = UIColor.blackColor()
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                backgroundColor = UIColor.blueColor()
            } else {
                backgroundColor = UIColor.blackColor()
            }
        }
    }

    
}
