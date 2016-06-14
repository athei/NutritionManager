//
//  DishDetail.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 11.10.15.
//
//

import Foundation
import UIKit
import CoreData

class DishDetail: UITableViewController, UITextFieldDelegate, DishCollectionProtocol {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var energyField: UITextField!
    
    // MARK: - Private variables
    private var presentingDish: Dish
    private let temporaryContext: NSManagedObjectContext
    
    // MARK: - Initializing
    
    required init?(coder aDecoder: NSCoder) {
        temporaryContext = Database.get().createMainQueueChild()
        presentingDish = Dish(context: temporaryContext)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // load the values from the model to the view
        // and set the controls to the appropriate mode (editing vs inspecting)
        super.setEditing(isNewDish(), animated: false)
        setControlsEditing(isEditing)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // end editing mode -> save changes or new entity
        if (!editing) {
            
            do {
                try presentingDish.name = Dish.checkName(nameField.text)
                
                if (isNewDish()) {
                    try! temporaryContext.save()
                }
                
                try! Database.get().moc.save()
                
                // all ok
                if (isNewDish()) {
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                print(error) // TODO: show error to user
                return // do not progress further (change state) when error occured
            }
        }
        
        // when no error occured while editing && view was not dissmissed (when it is a new dish)
        //  -> change state to editing/non editing
        if (!isNewDish()) {
            super.setEditing(editing, animated: animated)
            transitToEditing(editing, animated: animated)
        }
    }
    
    // MARK: - Actions
    
    func cancelEditing() {
        if (isNewDish()) {
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
                try Dish.checkName(newString)
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
    
    // MARK: - DishCollectionProtocol
    
    func dishSelected(_ dish: Dish) {
        navigationItem.title = dish.name
        presentingDish = dish
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
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(DishDetail.cancelEditing))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        fillControlsWithValues(withUnit: !editing)
        
        if (editing) {
            enableTextField(nameField)
            disableTextField(energyField)
        } else {
            disableTextField(nameField)
            disableTextField(energyField)
        }
    }
    
    
    private func fillControlsWithValues(withUnit: Bool) {
        if (!isNewDish()) {
            if let imgData = presentingDish.image {
                imageView.image = UIImage(data: imgData as Data)
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
            nameField.text = presentingDish.name
            energyField.text = presentingDish.formattedEnergy(withUnit: withUnit, to: nil)
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
    
    private func isNewDish() -> Bool {
        // a new dish is created annother context than the main one
        return presentingDish.managedObjectContext == temporaryContext
    }
}
