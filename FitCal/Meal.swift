//
//  Meal.swift
//  FitCal
//
//  Created by Natalia Consonni on 22/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

enum MealType: String {
    case Breakfast = "Breakfast"
    case Lunch = "Lunch"
    case Dinner = "Dinner"
    case Snack = "Snack"
}

class Meal: NSObject, NSCoding {
    
    var name: String
    var calories: Int
    var portion: Int
    var type: MealType
    
    init(_ name: String, _ calories: Int, _ portion: Int, _ type: MealType) {
        self.name = name
        self.calories = calories
        self.portion = portion
        self.type = type
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let calories = aDecoder.decodeObject(forKey: "calories") as! Int
        let portion = aDecoder.decodeObject(forKey: "portion") as! Int
        let typeStr = aDecoder.decodeObject(forKey: "type") as! String
        
        self.init(name,calories,portion,MealType(rawValue: typeStr)!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.calories, forKey: "calories")
        aCoder.encode(self.portion, forKey: "portion")
        aCoder.encode(self.type.rawValue, forKey: "type")

    }

}
