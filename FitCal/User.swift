//
//  User.swift
//  FitCal
//
//  Created by Natalia Consonni on 1/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String!
    var lastName: String!
    var uid: String!
    var urlImage: URL?
    var mealHistory: [String:[Meal]] = [String:[Meal]]()
    
    static let instance: User = User()
    
    init(_ firstName: String, _ lastName: String, _ uid: String, _ url: URL) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.urlImage = url
    }
    
    func addHistoryMeal(_ day: String, _ meal: Meal) {
        var mealList = self.mealHistory[day]
        if mealList == nil {
            mealList = [Meal]()
        }
        mealList?.append(meal)
        
        self.mealHistory[day] = mealList
    }
    
    init() {}
    
}
