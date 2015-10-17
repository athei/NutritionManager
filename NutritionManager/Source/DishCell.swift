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
    @IBOutlet weak var checkMark: SSCheckMark!
    
    var editing: Bool = false {
        didSet {
            checkMark.hidden = !editing
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMark.checkMarkStyle = .GrayedOut
    }
    
    
    override var selected: Bool {
        didSet {
            checkMark.checked = selected
        }
    }
}
