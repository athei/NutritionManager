//
//  IngredientDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import UIKit

class IngredientDetail: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydrateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private var presentingIngredient: Ingredient?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show control to show/close master view on iPad/iPhone+
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        
        // load the values from the model to the view
        if let ingredient = presentingIngredient {
            navigationItem.title = ingredient.name
            nameLabel.text = ingredient.name
            energyLabel.text = Units.formattedEnergy(energyInKcal: ingredient.energy, to: Units.Energy.Kcal)
            proteinLabel.text = Units.formattedMass(massInGram: ingredient.proteins, to: Units.Mass.Gram)
            fatLabel.text = Units.formattedMass(massInGram: ingredient.fat, to: Units.Mass.Gram)
            carbohydrateLabel.text = Units.formattedMass(massInGram: ingredient.carbohydrates, to: Units.Mass.Gram)
        }
    }
}

extension IngredientDetail: IngredientDetailViewProtocol {
    func ingredientSelected(ingredient: Ingredient) {
        presentingIngredient = ingredient
    }
}
