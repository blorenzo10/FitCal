//
//  Ingredient.swift
//  FitCal
//
//  Created by Natalia Consonni on 6/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class Ingredient {
    
    var name: String
    var quantity: Int
    
    init (_ name: String, _ quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
}
