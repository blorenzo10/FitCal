//
//  MealManager.swift
//  FitCal
//
//  Created by Natalia Consonni on 22/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class MealManager {
    
    var mealList: [Meal] = []
    
    static let instance: MealManager = MealManager()
    
    private init(){
        if mealList.isEmpty {
            self.retrieveData()
        }
    }
    
    func getMealList() -> [Meal] {
        return self.mealList
    }
    
    func persistData(){
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: mealList)
        defaults.set(encodedData, forKey: "lists")
        defaults.synchronize()
    }
    
    func retrieveData() {
        let defaults = UserDefaults.standard
        if let decoded  = defaults.object(forKey: "lists") as! Data? {
            self.mealList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Meal]
        }
    }
}
