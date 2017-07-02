//
//  SettingsManager.swift
//  FitCal
//
//  Created by Natalia Consonni on 24/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class SettingsManager {
    
    var settings: Settings = Settings()
    
    static let instance: SettingsManager = SettingsManager()
    
    private init(){
        retrieveData()
    }
    
    func persistData(){
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.settings)
        defaults.set(encodedData, forKey: "settings")
        defaults.synchronize()
    }
    
    func retrieveData() {
        let defaults = UserDefaults.standard
        if let decoded  = defaults.object(forKey: "settings") as! Data? {
            settings = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Settings
        }
    }
}
