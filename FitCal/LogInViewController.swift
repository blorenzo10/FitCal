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
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        if (self.emailLabel.text?.isEmpty)! || (self.passwordLabel.text?.isEmpty)! {
            self.showError(message: "You must enter the email address and the password to sign in")
        } else {
            let progressHUD = self.initializeProgress(message: "Sign in..")
            FIRAuth.auth()?.signIn(withEmail: self.emailLabel.text!, password: self.passwordLabel.text!) { (user, error) in
                
                if error != nil {
                    self.showError(message: (error?.localizedDescription)!)
                } else {
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    ref.child("Users").child((user?.uid)!).child("UserInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                        progressHUD.hideHUD()
                        
                        let value = snapshot.value as? NSDictionary
                        SettingsManager.instance.settings.goal = Goal(rawValue: value?["Goal"] as! String)
                        SettingsManager.instance.settings.activityLevel = ActivityLevel(rawValue: value?["Activity"] as! String)
                        SettingsManager.instance.settings.age = value?["Age"] as? Int
                        SettingsManager.instance.settings.age = value?["Tall"] as? Int
                        SettingsManager.instance.settings.age = value?["Weight"] as? Int
                        
                        User.instance.uid = user?.uid
                        self.performSegue(withIdentifier: "signin", sender: self)

                    })
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
    

}
