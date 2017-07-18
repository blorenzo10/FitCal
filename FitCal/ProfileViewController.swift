//
//  ProfileViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 24/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var recalculateCaloriesButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = User.instance.firstName + " " + User.instance.lastName
        self.caloriesLabel.text = String(Settings.instance.calories!)
        self.goalLabel.text = Settings.instance.goal?.rawValue
        self.activityLabel.text = Settings.instance.activityLevel?.rawValue
        
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2

        // Use the SDWebImage pod to download the image from firebase async.
        self.profileImage.setShowActivityIndicator(true)
        self.profileImage.setIndicatorStyle(.gray)
        self.profileImage.sd_setImage(with: User.instance.urlImage!)

        let imageSettings = UIImage(named: "SettingsImage")
        self.recalculateCaloriesButton.setImage(imageSettings, for: .normal)
        
        let imageLogOut = UIImage(named: "LogOutImage")
        self.logOutButton.setImage(imageLogOut, for: .normal)
        
        //self.view.backgroundColor = UIColor(red:72/255, green:124/255, blue:198/255, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? UINavigationController {
            if let setGoalController = nextViewController.viewControllers.first as? SetGoalViewController {
                setGoalController.uid = User.instance.uid
            }
        }
    }
    
    @IBAction func recalculateCalories(_ sender: Any) {
        performSegue(withIdentifier: "recalculate", sender: self)
    }

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            performSegue(withIdentifier: "signin", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
