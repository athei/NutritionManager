//
//  IngredientDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import UIKit

class IngredientDetail: UITableViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var energyField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    
    
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
            nameField.text = ingredient.name
            energyField.text = Units.formattedEnergy(energyInKcal: ingredient.energy, to: Units.Energy.Kcal)
            proteinField.text = Units.formattedMass(massInGram: ingredient.proteins, to: Units.Mass.Gram)
            fatField.text = Units.formattedMass(massInGram: ingredient.fat, to: Units.Mass.Gram)
            carbohydrateField.text = Units.formattedMass(massInGram: ingredient.carbohydrates, to: Units.Mass.Gram)
        }
    }
}

extension IngredientDetail: IngredientDetailViewProtocol {
    func ingredientSelected(ingredient: Ingredient) {
        navigationItem.title = ingredient.name
        presentingIngredient = ingredient
    }
}
