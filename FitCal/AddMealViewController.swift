//
//  AddMealViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 1/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import Firebase

protocol MealNotificacion {
    
    func notifyMealAdded(_ data: [String:Any])
}

class AddMealViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var protTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var ingredientList: UITableView!
    
    var quantityData: [Int] = []
    var ingredientQty: Int = 1
    var ingredientsData: [(String,Int)] = []
    
    var delegate: MealNotificacion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quantityPicker.dataSource = self
        self.quantityPicker.delegate = self
        
        self.ingredientNameTextField.delegate = self
        
        self.initPickerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMeal(_ sender: Any) {
        if (self.nameTextField.text?.isEmpty)! {
            self.nameTextField.shake()
        } else if (self.caloriesTextField.text?.isEmpty)! {
            self.caloriesTextField.shake()
        } else if (self.protTextField.text?.isEmpty)! {
            self.protTextField.shake()
        } else if (self.carbTextField.text?.isEmpty)! {
            self.carbTextField.shake()
        } else if (self.fatTextField.text?.isEmpty)! {
            self.fatTextField.shake()
        } else {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            
            let name = self.nameTextField.text!
            let calories = Int(self.caloriesTextField.text!)
            let prot = Int(self.protTextField.text!)
            let carb = Int(self.carbTextField.text!)
            let fat = Int(self.fatTextField.text!)
            
            let data: [String: Any] = ["Name": name,
                                       "Calories": calories!,
                                       "Prot" : prot!,
                                       "Carb" : carb!,
                                       "Fat" : fat!,
                                       "Ingredients": self.ingredientsData]
            
            ref.child("Users").child(User.instance.uid!).child("Meals").updateChildValues(data)
            
            self.delegate?.notifyMealAdded(data)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        if (self.ingredientNameTextField.text?.isEmpty)! {
            self.ingredientNameTextField.shake()
        } else {
            self.ingredientList.beginUpdates()
            let ingredient = (self.ingredientNameTextField!.text!,self.ingredientQty)
            self.ingredientsData.insert(ingredient, at: 0)
            self.ingredientList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.ingredientList.reloadData()
            self.ingredientNameTextField.text = ""
            self.ingredientList.endUpdates()
        }
    }
    
    // ++ Picker view protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.quantityData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let quantityString = String(self.quantityData[row])
        return quantityString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ingredientQty = self.quantityData[row]
    }
    // --
    
    // ++ UITableView DataSource protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredientsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell {
            let quantityStr = String(self.ingredientsData[indexPath.row].1)
            
            cell.nameLabel.text = self.ingredientsData[indexPath.row].0
            cell.quantityLabel.text = quantityStr
            return cell
        }
        return IngredientCell()
    }
    // --
    
    // ++ UITableView Delegate protocol
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        // Add de options in swipe view
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.ingredientList.beginUpdates()
            self.ingredientsData.remove(at: editActionsForRowAt.row)
            self.ingredientList.deleteRows(at: [editActionsForRowAt], with: UITableViewRowAnimation.fade)
            self.ingredientList.endUpdates()
        }
        
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    // --
    
    // ++ Custom funcion
    func initPickerData() {
        for i in 0...50 {
            self.quantityData.append(i+1)
        }
    }

    // --
}
