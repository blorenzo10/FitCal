//
//  MealList.swift
//  FitCal
//
//  Created by Natalia Consonni on 6/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class MealList {
    
    var mealList: [Meal] = []
    
    static let instance: MealList = MealList()
    
    private init(){}
    
    func getTotalOfCalories() -> Int {
        var calories = 0
        
        for meal in self.mealList {
            calories = calories + meal.calories
        }
        
        return calories
    }
    
    func getMacroInfo() -> [Double] {
        var macroInfo: [Double] = []
        
        var prot = 0.0
        var carb = 0.0
        var fat = 0.0
        
        for meal in self.mealList {
            prot = prot + meal.prot
            carb = carb + meal.carb
            fat = fat + meal.fat
        }
        
        macroInfo.append(prot)
        macroInfo.append(carb)
        macroInfo.append(fat)
        return macroInfo
    }
    
    func updateMacroInfo(mealId id: String, protein prot: Double, carbohydrates carb: Double, fats fat: Double) {
        for meal in self.mealList {
            if meal.id == id {
                meal.prot = prot
                meal.carb = carb
                meal.fat = fat
            }
        }
    }
    
}
