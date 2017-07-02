//
//  Settings.swift
//  FitCal
//
//  Created by Natalia Consonni on 23/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

enum Goal: String {
    case loseWeight = "Lose Weight"
    case gainWeight = "Gain Weight"
    case manteinWeight = "Maintain Weight"
}

enum ActivityLevel: String {
    case notVeryActive = "Not Very Active"
    case lightlyAvtive = "Lightly Active"
    case active = "Active"
    case veryActive = "Very Active"
}

class Settings: NSObject, NSCoding {
    
    var goal: Goal?
    var activityLevel: ActivityLevel?
    var age: Int?
    var tall: Int?
    var weight: Int?
    
    override init () {}
    
    init (_ goal: Goal, _ activityLevel: ActivityLevel, _ age: Int, _ tall: Int, _ weight: Int) {
        self.goal = goal
        self.activityLevel = activityLevel
        self.age = age
        self.tall = tall
        self.weight = weight
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let goal = aDecoder.decodeObject(forKey: "goal") as! String
        let activityLevel = aDecoder.decodeObject(forKey: "activityLevel") as! String
        let age = aDecoder.decodeObject(forKey: "age") as! Int
        let tall = aDecoder.decodeObject(forKey: "tall") as! Int
        let weight = aDecoder.decodeObject(forKey: "weight") as! Int

        self.init(Goal(rawValue: goal)!,ActivityLevel(rawValue: activityLevel)!,age,tall,weight)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.goal?.rawValue, forKey: "goal")
        aCoder.encode(self.activityLevel?.rawValue, forKey: "activityLevel")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.tall, forKey: "tall")
        aCoder.encode(self.weight, forKey: "weight")
        
    }
}
