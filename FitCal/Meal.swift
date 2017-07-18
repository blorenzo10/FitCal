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

class Meal {
    
    var id: String
    var name: String
    var calories: Int
    var prot: Double
    var carb: Double
    var fat: Double
    var ingredients: [Ingredient]?
    
    
    init(_ id: String, _ name: String, _ calories: Int, _ prot: Double, _ carb: Double, _ fat: Double) {
        self.id = id
        self.name = name
        self.calories = calories
        self.prot = prot
        self.carb = carb
        self.fat = fat
    }

}
