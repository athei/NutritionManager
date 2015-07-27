//
//  IngredientDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import UIKit
import CoreData

class IngredientDetail: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, IngredientDetailViewProtocol {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var energyField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    @IBOutlet weak var valueScaleControl: UISegmentedControl!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet var nonEditableConstraints: [NSLayoutConstraint]!
    @IBOutlet var editableConstraints: [NSLayoutConstraint]!
    
    private let categories: [Category]
    private var presentingIngredient: Ingredient?
    private var pendingIngredient: Ingredient?
    
    
    required init?(coder aDecoder: NSCoder) {
        // load the categories from the database
        let categoryFetch = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        categoryFetch.sortDescriptors = [sortDescriptor]
        try! categories = Database.get().moc.executeFetchRequest(categoryFetch) as! [Category]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // load the values from the model to the view
        // and set the controls to the appropriate mode (editing vs inspecting)
        super.setEditing(presentingIngredient == nil, animated: false)
        setControlsEditing(editing)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContraintsEditing(editing)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        // end editing mode -> save changes or new entity
        if (!editing) {
            let ingredient: Ingredient
            if (presentingIngredient == nil && pendingIngredient == nil) {
                ingredient = NSEntityDescription.insertNewObjectForEntityForName("Ingredient", inManagedObjectContext: Database.get().moc) as! Ingredient
                pendingIngredient = ingredient
            } else if (presentingIngredient != nil) {
                ingredient = presentingIngredient!
            } else {
                ingredient = pendingIngredient!
            }
            
            do {
                try ingredient.name = Ingredient.checkName(nameField.text)
                try ingredient.energy = Ingredient.checkEnergy(energyField.text)
                try ingredient.valueScale = Ingredient.checkValueScale(valueScaleControl.selectedSegmentIndex)
                try ingredient.proteins = Ingredient.checkProteins(proteinField.text)
                try ingredient.fat = Ingredient.checkFat(fatField.text)
                try ingredient.carbohydrates = Ingredient.checkCarbohydrates(carbohydrateField.text)
                ingredient.category = categories[categoryPicker.selectedRowInComponent(0)]
                
                try Database.get().moc.save()
                if (presentingIngredient == nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } catch {
                print(error)
                return
            }
        }
        
        if (presentingIngredient != nil) {
            super.setEditing(editing, animated: animated)
            transitToEditing(editing, animated: animated)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func cancelEditing() {
        if (presentingIngredient == nil) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            super.setEditing(false, animated: true)
            transitToEditing(false, animated: true)
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // MARK: IngredientDetailViewProtocol
    
    func ingredientSelected(ingredient: Ingredient) {
        navigationItem.title = ingredient.name
        presentingIngredient = ingredient
    }
    
    // MARK: Private helper
    
    private func transitToEditing(editing: Bool, animated: Bool) {
        if (animated) {
            view.layoutIfNeeded()
            UIView.animateWithDuration(0.4) { () -> Void in
                self.setControlsEditing(editing)
                self.view.layoutIfNeeded()
            }
        } else {
            setControlsEditing(editing)
        }
    }
    
    private func setControlsEditing(editing: Bool) {
        // show control to show/close master view on iPad/iPhone+
        // hide when editing
        if (editing) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelEditing")
            navigationItem.leftItemsSupplementBackButton = false
        } else {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        }
        
        fillControlsWithValues(withUnit: !editing)
        
        if (editing) {
            enableTextField(nameField)
            enableTextField(energyField)
            enableTextField(proteinField)
            enableTextField(fatField)
            enableTextField(carbohydrateField)
            valueScaleControl.enabled = true
            categoryLabel.hidden = true
            categoryPicker.hidden = false
        } else {
            disableTextField(nameField)
            disableTextField(energyField)
            disableTextField(proteinField)
            disableTextField(fatField)
            disableTextField(carbohydrateField)
            valueScaleControl.enabled = false
            categoryLabel.hidden = false
            categoryPicker.hidden = true
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
            categoryLabel.text = ingredient.category.name
            for i in 0..<categories.count {
                if (categories[i] == ingredient.category) {
                    categoryPicker.selectRow(i, inComponent: 0, animated: false)
                    break
                }
            }
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
