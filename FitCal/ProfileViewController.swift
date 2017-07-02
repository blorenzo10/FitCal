//
//  ProfileViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 24/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let age: Int = SettingsManager.instance.settings.age!
        //self.ageLabel.text = String(age)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
