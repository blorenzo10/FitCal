//
//  SetActivityLevelViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 23/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import StepProgressBar
import Firebase

class SetActivityLevelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewActivityLevels: UITableView!
    @IBOutlet weak var progressStep: StepProgressBar!
    
    var uid: String!
    var goal: Goal!
    var activity: ActivityLevel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.progressStep.stepsCount = 4
        self.progressStep.next()
        
        self.tableViewActivityLevels.tableFooterView = UIView()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityLevelCell", for: indexPath) as? SetActivityLevelCell {
            switch indexPath.row {
                case 0:
                    cell.titleLabel.text = "Not Very Active"
                    cell.descriptionLabel.text = "Spend most of the day sitting"
            
                case 1:
                    cell.titleLabel.text = "Lightly Active"
                    cell.descriptionLabel.text = "Spend a good part of your day on feet"
                
                case 2:
                    cell.titleLabel.text = "Active"
                    cell.descriptionLabel.text = "Speend a good part of the day doing some physical activity"
                
                default:
                    cell.titleLabel.text = "Very Active"
                    cell.descriptionLabel.text = "Spend most of the day doing heavy physical activity"
                
                
            }
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 0, green: 46/255, blue: 122/255, alpha: 1.0 ).cgColor
            cell.layer.borderWidth = 2.0
            return cell
        }
        
        return SetActivityLevelCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // --

    // ++ Delegate protocol
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SetActivityLevelCell
        cell.contentView.backgroundColor = UIColor(red: 0, green: 46/255, blue: 122/255, alpha: 1.0)
        cell.titleLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        
        self.activity = ActivityLevel(rawValue: cell.titleLabel!.text!)

        self.performSegue(withIdentifier: "setUserInfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SetActivityLevelCell
        cell.contentView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        cell.titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    // --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? SetUserInfoViewController {
            nextViewController.uid = self.uid
            nextViewController.goal = self.goal
            nextViewController.activity = self.activity
        }
    }
}
