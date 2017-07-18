//
//  SetGoalViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 22/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import StepProgressBar
import Firebase

class SetGoalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewGoals: UITableView!
    @IBOutlet weak var progressStep: StepProgressBar!
    
    var uid: String!
    var goal: Goal!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.progressStep.stepsCount = 4
        
        self.tableViewGoals.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ++ DataSource protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as? SetGoalCell {
            switch indexPath.row {
                case 1: cell.titleLabel.text = "Lose Weight"
                case 2: cell.titleLabel.text = "Maintain Weight"
                default: cell.titleLabel.text = "Gain Weight"
 
            }
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 0, green: 46/255, blue: 122/255, alpha: 1.0 ).cgColor
            cell.layer.borderWidth = 2.0
            return cell
        }
        
        return SetGoalCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }
    // --
    
    // ++ Delegate protocol
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SetGoalCell
        cell.contentView.backgroundColor = UIColor(red: 0, green: 46/255, blue: 122/255, alpha: 1.0)
        cell.titleLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        
        self.goal = Goal(rawValue: cell.titleLabel.text!)
        

        self.performSegue(withIdentifier: "setActivityLevel", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SetGoalCell
        cell.contentView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        cell.titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    // --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? SetActivityLevelViewController {
            nextViewController.uid = self.uid
            nextViewController.goal = self.goal
        }
        
    }

}
