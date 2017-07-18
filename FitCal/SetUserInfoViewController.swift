//
//  SetUserInfoViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 23/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import StepProgressBar
import Firebase

class SetUserInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var progressStep: StepProgressBar!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var tallTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var uid: String!
    var goal: Goal!
    var activity: ActivityLevel!
    var sex: String = "Male"
    var calories: Float!
    
    var sexData: [String] = ["Male","Female"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressStep.stepsCount = 4
        self.progressStep.next()
        self.progressStep.next()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func calculateCalories(_ sender: Any) {
        if self.thereAreEmptyFields() {
            self.showError(message: "There are some empty fields. Check and try again")
        } else {
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            let age: Int = Int(self.ageTextField.text!)!
            let tall: Int = Int(self.tallTextField.text!)!
            let weight: Int = Int(self.weightTextField.text!)!
            
            let data: [String: Any] = ["Goal": self.goal.rawValue,
                                       "Activity": self.activity.rawValue,
                                       "Age" : age,
                                       "Tall" : tall,
                                       "Weight" : weight,
                                       "Sex": self.sex]
            
            ref.child("Users").child(self.uid).child("UserInfo").updateChildValues(data)
            
            // Calculate calories
            self.calories = CaloriesUtils().calculateDailyCalories(self.goal, self.activity, age, tall, weight, sex: Sex(rawValue: self.sex)!)
            
            Settings.instance.activityLevel = self.activity
            Settings.instance.age = age
            Settings.instance.tall = tall
            Settings.instance.weight = weight
            Settings.instance.goal = self.goal
            
            performSegue(withIdentifier: "setProfile", sender: self)
        }
    }
    
    // ++ Picker view protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return self.sexData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sexData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sex = self.sexData[row]
    }
    // --
    
    func showError(message msg: String) {
        let errorAlterController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        errorAlterController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlterController, animated: true, completion: nil)
    }
    
    
    private func thereAreEmptyFields() -> Bool {
        if (self.ageTextField.text?.isEmpty)! || (self.tallTextField.text?.isEmpty)! || (self.weightTextField.text?.isEmpty)!{
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? SetUserProfileViewController {
            nextViewController.calories = Int(self.calories)
            nextViewController.uid = self.uid
        }
    }

}
