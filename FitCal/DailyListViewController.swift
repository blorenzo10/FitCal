//
//  DailyListViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 22/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import GTProgressBar
import Firebase
import EFCountingLabel

class DailyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MealNotificacion {

    var list: [Meal] = []
    
    @IBOutlet weak var mealTableView: UITableView!
    @IBOutlet weak var totalCaloriesLabel: EFCountingLabel!
    @IBOutlet weak var protPercentageLabel: EFCountingLabel!
    @IBOutlet weak var carbPercentageLabel: EFCountingLabel!
    @IBOutlet weak var fatPercentageLabel: EFCountingLabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    
    var caloriesCount: Int = 0
    var protGrams: Double = 0
    var carbGrams: Double = 0
    var fatGrams: Double = 0
    var caloriesPercentage: CGFloat = 0.0
    var addedMeal: [Meal] = []
    var lastAddedMealCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the progress of calories properties
        self.progressBar.barBorderWidth = 1
        self.progressBar.barBorderColor = UIColor(red:23/255, green:70/255, blue:150/255, alpha:1.0)
        self.progressBar.barFillColor = UIColor(red:23/255, green:70/255, blue:145/255, alpha:1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if (self.addedMeal.count) > 0  {
            self.notifyHistoricMealAdded(self.addedMeal)
            self.addedMeal.removeAll()
        }
        
        // Get the current list
        self.list = MealList.instance.mealList
        
        self.caloriesCount = MealList.instance.getTotalOfCalories()
        
        //self.showTableCells()
        
        // Set the percentage of calories
        self.setCaloriesPercentage()
        
        // Set the total of calories and macro
        self.setCaloriesLabel(caloriesCount)
        
        let macroInfo = MealList.instance.getMacroInfo()
        self.setMacroInfo(CaloriesUtils().calculateMacronutrientsCalories(protein: macroInfo[0], carbohydrates: macroInfo[1], fats: macroInfo[2]))
        
    }

    // ++ UITableViewDataSource protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! DailyListCell
        cell.mealNameLabel.text = self.list[indexPath.row].name
        cell.mealCalLabel.text = String(self.list[indexPath.row].calories)
        cell.mealMacroLabel.text = String(self.list[indexPath.row].prot) + " gm Prot - " + String(self.list[indexPath.row].carb) + " gm Carb - " + String(self.list[indexPath.row].fat) + " gm Fat"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    // --
    
    // ++ MealNotificacion protocol
    func notifyMealAdded(_ data: [String:Any], _ firebaseKey: String) {
        let cal = data["Calories"] as! Int
        let prot = data["Prot"] as! Double
        let carb = data["Carb"] as! Double
        let fat = data["Fat"] as! Double
        
        let meal = Meal(firebaseKey, data["Name"] as! String, cal, prot, carb, fat)
        self.list.append(meal)
        MealList.instance.mealList.append(meal)
        
        self.caloriesCount = self.caloriesCount + cal
        self.setCaloriesLabel(self.caloriesCount)
        
        
        self.protGrams = self.protGrams + prot
        self.carbGrams = self.carbGrams + carb
        self.fatGrams = self.fatGrams + fat
        
        let macroInfo = CaloriesUtils().calculateMacronutrientsCalories(protein: self.protGrams, carbohydrates: self.carbGrams, fats: self.fatGrams)
        
        self.setMacroInfo(macroInfo)
        self.setCaloriesPercentage()
        
        self.mealTableView.reloadData()
    }
    // --

    // ++ UITableView Delegate protocol
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        // Add de options in swipe view
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.mealTableView.beginUpdates()
            
            let idOfDeletedMeal = self.list[editActionsForRowAt.row].id
            let caloriesOfDeletedMeal = self.list[editActionsForRowAt.row].calories
            let protOfDeletedMeal = self.list[editActionsForRowAt.row].prot
            let carbOfDeletedMeal = self.list[editActionsForRowAt.row].carb
            let fatOfDeletedMeal = self.list[editActionsForRowAt.row].fat
            
            MealList.instance.mealList.remove(at: editActionsForRowAt.row)
            self.list.remove(at: editActionsForRowAt.row)
            self.mealTableView.deleteRows(at: [editActionsForRowAt], with: UITableViewRowAnimation.fade)
            
            self.caloriesCount = self.caloriesCount - caloriesOfDeletedMeal
            
            let macroInfo = MealList.instance.getMacroInfo()
            self.setMacroInfo(CaloriesUtils().calculateMacronutrientsCalories(protein: macroInfo[0]-protOfDeletedMeal, carbohydrates: macroInfo[1]-carbOfDeletedMeal, fats: macroInfo[2]-fatOfDeletedMeal))
           
            self.setCaloriesLabel(self.caloriesCount)
            self.setCaloriesPercentage()
            

            self.mealTableView.endUpdates()
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            var currentDate = Utils().getCurrentDate()
            currentDate = currentDate.replacingOccurrences(of: "/", with: "-")
            
            ref.child("Users").child(User.instance.uid!).child("Meals").child(currentDate).child(idOfDeletedMeal).removeValue()
            
            self.deleteAddedMeal(idOfDeletedMeal)
        }
        
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.mealTableView.deselectRow(at: indexPath, animated: true)
    }
    // --

    
    // ++ Custom function
    func setMacroInfo(_ macroInfo: [Double]) {
        let totalCal = Double(self.caloriesCount)
        
        var protPercentage: Int
        var carbPercentage: Int
        var fatPercentage: Int
        
        if totalCal != 0 {
            protPercentage = Int((macroInfo[0]/totalCal)*100)
            carbPercentage = Int((macroInfo[1]/totalCal)*100)
            fatPercentage = 100 - (protPercentage + carbPercentage)
        } else {
            protPercentage = 0
            carbPercentage = 0
            fatPercentage = 0
        }
        
        self.protPercentageLabel.format = "%d"
        self.protPercentageLabel.method = .easeInOut
        self.protPercentageLabel.countFrom(0.0, to: CGFloat(protPercentage), withDuration: 1.0)
        
        self.carbPercentageLabel.format = "%d"
        self.carbPercentageLabel.method = .easeInOut
        self.carbPercentageLabel.countFrom(0.0, to: CGFloat(carbPercentage), withDuration: 1.0)
        
        self.fatPercentageLabel.format = "%d"
        self.fatPercentageLabel.method = .easeInOut
        self.fatPercentageLabel.countFrom(0.0, to: CGFloat(fatPercentage), withDuration: 1.0)
        
    }
    
     
    func getCaloriesPercentage() -> Double{
        var caloriesPercentage: Double = 0.0
        let totalCalories = Settings.instance.calories!
        let caloriesCount = self.caloriesCount
        if caloriesCount != 0 {
            caloriesPercentage = Double(caloriesCount) / Double(totalCalories)
        }
        
        return caloriesPercentage
    }
    
    func setCaloriesPercentage() {
        let caloriesPercentage = self.getCaloriesPercentage()
        self.progressBar.progress = 0.0
        self.progressBar.animateTo(progress: CGFloat(caloriesPercentage))
    }
    
    func setCaloriesLabel(_ cal: Int) {
        //self.totalCaloriesLabel.text! = String(cal)
        self.totalCaloriesLabel.format = "%d"
        self.totalCaloriesLabel.method = .easeInOut
        self.totalCaloriesLabel.countFrom(0.0, to: CGFloat(cal), withDuration: 1.0)
    }
    
    func showTableCells() {
        self.mealTableView.reloadData()
        
        let cells = self.mealTableView.visibleCells
        let tableHeight: CGFloat = self.mealTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for cell in cells {
            
            UIView.animate(withDuration: 2.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: {
                completed in
            })
            
            index += 1
        }
    }
    // --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? AddMealViewController {
            next.delegate = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func notifyHistoricMealAdded(_ mealList: [Meal]) {
        for meal in mealList {
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            var currentDate = Utils().getCurrentDate()
            currentDate = currentDate.replacingOccurrences(of: "/", with: "-")
            
            //let key = ref.child("Users").child(User.instance.uid!).child("Meals").child(currentDate).childByAutoId().key
            let key = meal.id
            
            let name = meal.name
            let calories = meal.calories
            let prot = meal.prot
            let carb = meal.carb
            let fat = meal.fat
            
            let data: [String: Any] = ["Name": name,
                                       "Calories": calories,
                                       "Prot" : prot,
                                       "Carb" : carb,
                                       "Fat" : fat]
            
            ref.child("Users").child(User.instance.uid!).child("Meals").child(currentDate).child(key).updateChildValues(data)
            
            self.list.append(meal)
            MealList.instance.mealList.append(meal)
            
            self.caloriesCount = self.caloriesCount + calories
            self.setCaloriesLabel(self.caloriesCount)
            
            
            self.protGrams = self.protGrams + prot
            self.carbGrams = self.carbGrams + carb
            self.fatGrams = self.fatGrams + fat
            
            let macroInfo = CaloriesUtils().calculateMacronutrientsCalories(protein: self.protGrams, carbohydrates: self.carbGrams, fats: self.fatGrams)
            
            self.setMacroInfo(macroInfo)
            self.setCaloriesPercentage()
            
            self.mealTableView.reloadData()

        }
    }
    
    func deleteAddedMeal(_ idOfDeletedMeal: String) {
 
        if (self.addedMeal.count) > 0 {
            for i in 0...(self.addedMeal.count)-1 {
                if self.addedMeal[i].id == idOfDeletedMeal {
                    self.addedMeal.remove(at: i)
                }
            }
        }
    
    }

}
