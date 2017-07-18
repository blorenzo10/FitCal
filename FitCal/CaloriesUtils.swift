//
//  CaloriesUtil.swift
//  FitCal
//
//  Created by Natalia Consonni on 28/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

enum Sex: String {
    case Male = "Male"
    case Female = "Female"
}

class CaloriesUtils {
    
    func calculateDailyCalories(_ goal: Goal, _ activity: ActivityLevel, _ age: Int, _ tall: Int, _ weight: Int, sex: Sex) -> Float {
        var basalMetabolism: Float
        var weightCount: Float
        var tallCount: Float
        var ageCount: Float
        var calories: Float
        
        if sex == .Male {
            weightCount = 13.751 * Float(weight)
            tallCount = 5.0033 * Float(tall)
            ageCount = 6.7550 * Float(age)
            basalMetabolism =  66.473 + (weightCount) + (tallCount) - (ageCount)
            
        } else {
            
            weightCount = 9.463 * Float(weight)
            tallCount = 1.8 * Float(tall)
            ageCount = 4.6756 * Float(age)
            basalMetabolism =  655.1 + (weightCount) + (tallCount) - (ageCount)
        }

        switch activity {
            case .notVeryActive:
                    calories = basalMetabolism * 1.2
            case .lightlyAvtive:
                    calories = basalMetabolism * 1.375
            case .active:
                calories = basalMetabolism * 1.55
            default:
                calories = basalMetabolism * 1.725
        }
        
        switch goal {
            case .gainWeight:
                return calories + 500
            case .loseWeight:
                return calories - 500
            default:
                return calories
        }
    }
    
    func calculateMacronutrientsCalories(protein prot: Double, carbohydrates carb: Double, fats fat: Double) -> [Double] {
        // Hidratos y proteinas 4 cal por gramo. Grasas 9 cal por gramo
        let protCal = prot * 4
        let carbCal = carb * 4
        let fatCal = fat * 9
        
        return [protCal,carbCal,fatCal]
    }

}
