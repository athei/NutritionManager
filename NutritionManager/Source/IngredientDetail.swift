//
//  IngredientDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 23.07.15.
//
//

import UIKit
import CoreData

class IngredientDetail: UITableViewController, UITextFieldDelegate, IngredientListProtocol, CategoryListProtocol {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var energyField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    @IBOutlet weak var valueScaleControl: UISegmentedControl!
    @IBOutlet weak var categoryCell: UITableViewCell!
    @IBOutlet var nonEditableConstraints: [NSLayoutConstraint]!
    @IBOutlet var editableConstraints: [NSLayoutConstraint]!
   
    // MARK: - Private variables
    private var presentingIngredient: Ingredient?
    private var selectedCategory: Category?
    
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // load the values from the model to the view
        // and set the controls to the appropriate mode (editing vs inspecting)
        super.setEditing(isNewIngredient(), animated: false)
        setControlsEditing(isEditing)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case "CategoryPicker":
            let categoryPicker = segue.destinationViewController as! CategoryList
            categoryPicker.delegate = self
            break;
            
        default:
            assert(false, "Unknown Segue")
            break
        }
    }
    
    // MARK: - Editing
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContraintsEditing(isEditing)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // end editing mode -> save changes or new entity
        if (!editing) {
            var temporaryContext: NSManagedObjectContext? // used to store a temporary entity while validating
            let ingredient: Ingredient  // the ingredient which is subject to editing
            if (isNewIngredient()) {
                temporaryContext = Database.get().createMainQueueChild()
                ingredient = Ingredient(context: temporaryContext!)
            } else {
                ingredient = presentingIngredient!
            }
            
            do {
                try ingredient.name = Ingredient.checkName(nameField.text)
                try ingredient.energy = Ingredient.checkEnergy(energyField.text)
                try ingredient.valueScale = Ingredient.checkValueScale(valueScaleControl.selectedSegmentIndex)
                try ingredient.proteins = Ingredient.checkProteins(proteinField.text)
                try ingredient.fat = Ingredient.checkFat(fatField.text)
                try ingredient.carbohydrates = Ingredient.checkCarbohydrates(carbohydrateField.text)
                
                let category = try Ingredient.checkCategory(selectedCategory)
                
                // new entity was saved to temporary context -> apply to main context by saving
                if (isNewIngredient()) {
                    // since we are using a childcontext we can't use a category
                    // object from the parent context
                    ingredient.category = temporaryContext!.object(with: category.objectID) as! Category
                    try! temporaryContext!.save()
                } else {
                    ingredient.category = category
                }
                
                try! Database.get().moc.save()
                
                // all ok
                if (isNewIngredient()) {
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                print(error) // TODO: show error to user
                return // do not progress further (change state) when error occured
            }
        }
        
        // when no error occured while editing && view was not dissmissed (when it is a new ingredient)
        //  -> change state to editing/non editing
        if (!isNewIngredient()) {
            super.setEditing(editing, animated: animated)
            transitToEditing(editing, animated: animated)
        }
    }
    
    // MARK: - Actions
    
    func cancelEditing() {
        if (isNewIngredient()) {
            dismiss(animated: true, completion: nil)
        } else {
            super.setEditing(false, animated: true)
            transitToEditing(false, animated: true)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // we only allow highlight and select of the category cell when editingmode is on
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return isEditing
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (isEditing) {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // always allow the user to backspace the whole field
        if (newString.characters.count == 0) {
            return true
        }
        
        do {
            switch textField {
            case nameField:
                try Ingredient.checkName(newString)
                break
            case energyField:
                try Ingredient.checkEnergy(newString)
                break
            case proteinField:
                try Ingredient.checkProteins(newString)
                break
            case fatField:
                try Ingredient.checkFat(newString)
                break
            case carbohydrateField:
                try Ingredient.checkCarbohydrates(newString)
                break
            default:
                break
            }
            // when no method has thrown -> accept the input
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - IngredientDetailViewProtocol
    
    func ingredientSelected(_ ingredient: Ingredient) {
        navigationItem.title = ingredient.name
        presentingIngredient = ingredient
        selectedCategory = ingredient.category
    }
    
    
    // MARK: - CategoryListProtocol
    
    func categoryList(_ categoryList: CategoryList, didSelectCategory category: Category) {
        selectedCategory = category
        categoryCell.textLabel?.text = category.name
    }
    
    func categoryList(_ categoryList: CategoryList, didChangeCategory category: Category) {
        if (selectedCategory == category) {
            categoryCell.textLabel?.text = category.name
        }
    }
    
    // MARK: - Private Helper
    
    private func transitToEditing(_ editing: Bool, animated: Bool) {
        if (animated) {
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4) { () -> Void in
                self.setControlsEditing(editing)
                self.view.layoutIfNeeded()
            }
        } else {
            setControlsEditing(editing)
        }
    }
    
    private func setControlsEditing(_ editing: Bool) {
        // show control to show/close master view on iPad/iPhone+
        // hide when editing
        if (editing) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(IngredientDetail.cancelEditing))
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
            categoryCell.accessoryType = .disclosureIndicator
            if (isNewIngredient() || presentingIngredient!.dishes.count == 0) {
               valueScaleControl.isEnabled = true
            }
        } else {
            disableTextField(nameField)
            disableTextField(energyField)
            disableTextField(proteinField)
            disableTextField(fatField)
            disableTextField(carbohydrateField)
            categoryCell.accessoryType = .none
            valueScaleControl.isEnabled = false
        }
    }
    
    private func setContraintsEditing(_ editing: Bool) {
        // we need to make sure to deakcivate constraints before activating new ones
        if (editing) {
            for constraint in nonEditableConstraints {
                constraint.isActive = false
            }
            
            for constraint in editableConstraints {
                constraint.isActive = true
            }
        } else {
            for constraint in editableConstraints {
                constraint.isActive = false
            }
            
            for constraint in nonEditableConstraints {
                constraint.isActive = true
            }
        }
    }
    
    private func fillControlsWithValues(withUnit: Bool) {
        if let ingredient = presentingIngredient {
            if let imgData = ingredient.image {
                imageView.image = UIImage(data: imgData as Data)
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
            nameField.text = ingredient.name
            energyField.text = ingredient.formattedEnergy(withUnit: withUnit, to: nil)
            proteinField.text = ingredient.formattedProteins(withUnit: withUnit, to: nil)
            fatField.text = ingredient.formattedFat(withUnit: withUnit, to: nil)
            carbohydrateField.text = ingredient.formattedCarbohydrates(withUnit: withUnit, to: nil)
            valueScaleControl.selectedSegmentIndex = ingredient.valueScale.rawValue
            categoryCell.textLabel?.text = ingredient.category.name
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func enableTextField(_ field: UITextField) {
        field.borderStyle = UITextBorderStyle.roundedRect
        field.isEnabled = true
    }
    
    private func disableTextField(_ field: UITextField) {
        field.borderStyle = UITextBorderStyle.none
        field.isEnabled = false
    }
    
    private func isNewIngredient() -> Bool {
        return presentingIngredient == nil;
    }
}
