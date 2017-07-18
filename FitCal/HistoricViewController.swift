//
//  HistoricViewCellViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 12/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit


class HistoricViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historicTableView: UITableView!
    
    
    var historicList: [String:[Meal]]!
    var dayList: [String] = []
    var addMeal: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.historicList = User.instance.mealHistory
        self.setDayList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.historicTableView.reloadData()
    }
    @IBAction func addMeals(_ sender: Any) {
        let nextViewController = self.tabBarController?.viewControllers?[0] as! DailyListViewController
        
        for meal in self.addMeal {
            nextViewController.addedMeal.append(Meal(meal.id, meal.name, meal.calories, meal.prot, meal.carb, meal.fat))
        }
        self.addMeal.removeAll()
        self.tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? DailyListViewController {
            nextViewController.addedMeal = self.addMeal
        }
    }
    
    // ++ UITableViewDataSource protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.historicList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let day = self.dayList[section]
        return (self.historicList[day]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricCell", for: indexPath) as! HistoricMealCell
        
        let day = self.dayList[indexPath.section]

        cell.mealNameLabel.text = self.historicList[day]?[indexPath.row].name
        cell.checkIcon.isHidden = true
        cell.check = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.dayList[section]
    }
    
    // --

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let day = self.dayList[indexPath.section]
        let meal = self.historicList[day]?[indexPath.row]
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! HistoricMealCell
        
        if selectedCell.check {
            selectedCell.checkIcon.isHidden = true
            selectedCell.check = false
            
            self.removeMeal((meal?.id)!)
        } else {
            selectedCell.checkIcon.isHidden = false
            selectedCell.check = true
            
            self.addMeal.append(meal!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setDayList() {
        for (key,_) in self.historicList {
            self.dayList.append(key)
        }
    }
    
    func removeMeal(_ id: String) {
        for i in 0...self.addMeal.count {
            if self.addMeal[i].id == id {
                self.addMeal.remove(at: i)
                break
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
