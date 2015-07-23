//
//  IngredientDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import UIKit

class IngredientDetail: UITableViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    }
}

extension IngredientDetail: IngredientDetailViewProtocol {
    func ingredientSelected(ingredient: Ingredient) {
        navigationItem.title = ingredient.name
    }
}
