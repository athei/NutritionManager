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
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // show control to show/close master view on iPad/iPhone+
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        
        // load the values from the model to the view
        if let ingredient = presentingIngredient {
            nameField.text = ingredient.name
            energyField.text = ingredient.formattedEnergy(withUnit: true, to: nil)
            proteinField.text = ingredient.formattedProteins(withUnit: true, to: nil)
            fatField.text = ingredient.formattedFat(withUnit: true, to: nil)
            carbohydrateField.text = ingredient.formattedCarbohydrates(withUnit: true, to: nil)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            enableTextField(nameField)
            enableTextField(energyField)
            enableTextField(proteinField)
            enableTextField(fatField)
            enableTextField(carbohydrateField)
        } else {
            disableTextField(nameField)
            disableTextField(energyField)
            disableTextField(proteinField)
            disableTextField(fatField)
            disableTextField(carbohydrateField)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    private func enableTextField(field: UITextField) {
        field.borderStyle = UITextBorderStyle.RoundedRect
        field.enabled = true
    }
    
    private func disableTextField(field: UITextField) {
        field.borderStyle = UITextBorderStyle.None
        field.enabled = false
    }
}

extension IngredientDetail: IngredientDetailViewProtocol {
    func ingredientSelected(ingredient: Ingredient) {
        navigationItem.title = ingredient.name
        presentingIngredient = ingredient
    }
}
