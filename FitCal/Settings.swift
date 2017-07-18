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

class Settings {
    
    var goal: Goal?
    var activityLevel: ActivityLevel?
    var age: Int?
    var tall: Int?
    var weight: Int?
    var calories: Int?
    
    static let instance: Settings = Settings()
    
    private init () {}
    
    init (_ goal: Goal, _ activityLevel: ActivityLevel, _ age: Int, _ tall: Int, _ weight: Int, _ calories: Int) {
        self.goal = goal
        self.activityLevel = activityLevel
        self.age = age
        self.tall = tall
        self.weight = weight
        self.calories = calories
    }
    
}
