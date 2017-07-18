//
//  LogInViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 21/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import Firebase
import ACProgressHUD_Swift

class LogInViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        // Clear the list
        MealList.instance.mealList.removeAll()
        User.instance.mealHistory.removeAll()
        
        self.view.backgroundColor = UIColor(red:33/255, green:76/255, blue:145/255, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        if (self.emailTextField.text?.isEmpty)! || (self.passwordTextField.text?.isEmpty)! {
            self.showError(message: "You must enter the email address and the password to sign in")
        } else {
            let progressHUD = self.initializeProgress(message: "Sign in..")
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    progressHUD.hideHUD()
                    self.showError(message: (error?.localizedDescription)!)
                } else {
                    
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: "gs://fitnut-fa15d.appspot.com")
                    let profileImagePath = "images/Profile_" + (user?.uid)! + ".jpg"
                    let pathReference = storageRef.child(profileImagePath)
                    
                    pathReference.downloadURL { (URL, error) in
                        if error != nil {
                            print(error.debugDescription)
                        } else {
                            User.instance.urlImage = URL!
                            
                            var ref: FIRDatabaseReference!
                            ref = FIRDatabase.database().reference()
                            ref.child("Users").child((user?.uid)!).child("UserInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                                progressHUD.hideHUD()
                                
                                let value = snapshot.value as? NSDictionary
                                Settings.instance.goal = Goal(rawValue: value?["Goal"] as! String)
                                Settings.instance.activityLevel = ActivityLevel(rawValue: value?["Activity"] as! String)
                                Settings.instance.age = value?["Age"] as? Int
                                Settings.instance.age = value?["Tall"] as? Int
                                Settings.instance.age = value?["Weight"] as? Int
                                Settings.instance.calories = value?["Calories"] as? Int
                                
                                User.instance.uid = user?.uid
                                User.instance.firstName = value?["FirstName"] as? String
                                User.instance.lastName = value?["LastName"] as? String
                                
                                var currentDate = Utils().getCurrentDate()
                                currentDate = currentDate.replacingOccurrences(of: "/", with: "-")
                                
                                ref.child("Users").child((user?.uid)!).child("Meals").observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    if let mealHistory = snapshot.value as? NSDictionary {
                                        for (day, value) in mealHistory {
                                            if day as! String != currentDate {
                                                if let mealsOfDay = value as? NSDictionary {
                                                    for (mealKey, value) in mealsOfDay {
                                                        if let mealInfo = value as? NSDictionary {
                                                            let meal = self.createMeal(mealKey as! String, mealInfo)
                                                            if meal != nil {
                                                                User.instance.addHistoryMeal((day as? String)!, meal!)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                })
                                
        
                                ref.child("Users").child((user?.uid)!).child("Meals").child(currentDate).observeSingleEvent(of: .value, with: {
                                    (snapshot) in
                                    
                                    if let meals = snapshot.value as? NSDictionary {
                                        for (key,keyValue) in meals {
                                            let mealInfo = keyValue as! NSDictionary
                                            
                                            let mealId = key as! String
                                            let mealName = mealInfo["Name"] as! String
                                            let mealCalories = mealInfo["Calories"] as! Int
                                            let mealProt = mealInfo["Prot"] as! Double
                                            let mealCarb = mealInfo["Carb"] as! Double
                                            let mealFat = mealInfo["Fat"] as! Double
                                            
                                            let meal = Meal(mealId,mealName,mealCalories,mealProt,mealCarb,mealFat)
                                            
                                            if let ingredients = mealInfo["Ingredients"] as? NSDictionary{
                                                meal.ingredients = []
                                                for (key,value) in ingredients {
                                                    meal.ingredients?.append(Ingredient(key as! String, value as! Int))
                                                }
                                            }
                                            
                                            MealList.instance.mealList.append(meal)
                                        }
                                        
                                        self.performSegue(withIdentifier: "signin", sender: self)
                                    } else {
                                        self.performSegue(withIdentifier: "signin", sender: self)
                                    }
                                    
                                })
                                
                                
                            })
                        }
                    }
                }
            }
        }
    }

    func showError(message msg: String) {
        let errorAlterController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        errorAlterController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlterController, animated: true, completion: nil)
    }
    
    func initializeProgress(message msg: String) -> ACProgressHUD {
        let progressView = ACProgressHUD.shared
        progressView.progressText = msg
        progressView.showHUD()
        return progressView
    }
    
    func createMeal(_ id: String, _ dic: NSDictionary) -> Meal? {
            
        
        let mealName = dic["Name"] as! String
        let mealCalories = dic["Calories"] as! Int
        let mealProt = dic["Prot"] as! Double
        let mealCarb = dic["Carb"] as! Double
        let mealFat = dic["Fat"] as! Double
        
        let meal = Meal(id,mealName,mealCalories,mealProt,mealCarb,mealFat)
        
        if let ingredients = dic["Ingredients"] as? NSDictionary{
            meal.ingredients = []
            for (key,value) in ingredients {
                meal.ingredients?.append(Ingredient(key as! String, value as! Int))
            }
        }
        
        return meal
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
