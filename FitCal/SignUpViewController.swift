//
//  SignUpViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 21/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import Firebase
import ACProgressHUD_Swift

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UITextField!
    
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if self.thereAreEmptyFields() {
            self.showError(message: "There are some empty fields. Check and try again")
        } else {
            if !self.passwordSizeEnough() {
                self.showError(message: "The size of the password is too short")
            } else {
                if !self.passwordMatch() {
                    self.showError(message: "The password doesn't match. Chech and try again")
                } else {
                    let progressHUD = self.initializeProgress(message: "Creating account..")
                    FIRAuth.auth()?.createUser(withEmail: self.emailLabel.text!, password: self.passwordLabel.text!) { (user,error) in
                        progressHUD.hideHUD()
                        if error != nil {
                            self.showError(message: "There was an error on the server. Please try again latter")
                        } else {
                            
                            self.uid = user?.uid
                            User.instance.uid = user?.uid
                            
                            var ref: FIRDatabaseReference!
                            ref = FIRDatabase.database().reference()
                            
                            let data: [String: Any] = ["FirstName" : self.firstNameLabel.text!,
                                                       "LastName" : self.lastNameLabel.text!]
                            
                            ref.child("Users").child((user?.uid)!).child("UserInfo").setValue(data)
                            
                            User.instance.firstName = self.firstNameLabel.text!
                            User.instance.lastName = self.lastNameLabel.text!
                            
                            self.performSegue(withIdentifier: "setGoal", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    private func thereAreEmptyFields() -> Bool {
        if (self.emailLabel.text?.isEmpty)! || (self.passwordLabel.text?.isEmpty)! || (self.repeatPasswordLabel.text?.isEmpty)! || (self.firstNameLabel.text?.isEmpty)! || (self.lastNameLabel.text?.isEmpty)!{
            return true
        }
        return false
    }
    
    private func passwordSizeEnough() -> Bool {
        if (self.passwordLabel.text?.characters.count)! < 6 {
            return false
        }
        return true
    }
    private func passwordMatch() -> Bool {
        if self.passwordLabel.text != self.repeatPasswordLabel.text {
            return false
        }
        return true
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
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? UINavigationController {
            if let setGoalController = nextViewController.viewControllers.first as? SetGoalViewController {
                setGoalController.uid = self.uid
            }
        }
        
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
