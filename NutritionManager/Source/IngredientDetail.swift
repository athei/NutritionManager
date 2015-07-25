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
    @IBOutlet weak var valueScaleControl: UISegmentedControl!
    
    @IBOutlet var nonEditableConstraints: [NSLayoutConstraint]!
    @IBOutlet var editableConstraints: [NSLayoutConstraint]!
    
    
    private var presentingIngredient: Ingredient?
    private var initialLayoutDone: Bool = false
    
    
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
        // and set the controls to the appropriate mode (editing vs inspecting)
        setControlsEditing(presentingIngredient == nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // the constraints can only be changed set after the initial layout
        // of the view is done
        if (!initialLayoutDone) {
            setContraintsEditing(presentingIngredient == nil)
            initialLayoutDone = true
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (animated) {
            UIView.animateWithDuration(1.0) { () -> Void in
                self.setControlsEditing(editing)
                self.setContraintsEditing(editing)
                self.view.layoutIfNeeded()
            }
        } else {
            setControlsEditing(editing)
            setContraintsEditing(editing)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    private func setControlsEditing(editing: Bool) {
        fillControlsWithValues(withUnit: !editing)
        
        if (editing) {
            enableTextField(nameField)
            enableTextField(energyField)
            enableTextField(proteinField)
            enableTextField(fatField)
            enableTextField(carbohydrateField)
            valueScaleControl.enabled = true;
            
        } else {
            disableTextField(nameField)
            disableTextField(energyField)
            disableTextField(proteinField)
            disableTextField(fatField)
            disableTextField(carbohydrateField)
            valueScaleControl.enabled = false
            fillControlsWithValues(withUnit: !editing)
        }
    }
    
    private func setContraintsEditing(editing: Bool) {
        // we need to make sure to deakcivate constraints before activating new ones
        if (editing) {
            for constraint in nonEditableConstraints {
                constraint.active = false
            }
            
            for constraint in editableConstraints {
                constraint.active = true
            }
        } else {
            for constraint in editableConstraints {
                constraint.active = false
            }
            
            for constraint in nonEditableConstraints {
                constraint.active = true
            }
        }
    }
    
    private func fillControlsWithValues(withUnit withUnit: Bool) {
        if let ingredient = presentingIngredient {
            nameField.text = ingredient.name
            energyField.text = ingredient.formattedEnergy(withUnit: withUnit, to: nil)
            proteinField.text = ingredient.formattedProteins(withUnit: withUnit, to: nil)
            fatField.text = ingredient.formattedFat(withUnit: withUnit, to: nil)
            carbohydrateField.text = ingredient.formattedCarbohydrates(withUnit: withUnit, to: nil)
            valueScaleControl.selectedSegmentIndex = ingredient.valueScale.rawValue
        }
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
