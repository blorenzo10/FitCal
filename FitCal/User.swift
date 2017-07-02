//
//  User.swift
//  FitCal
//
//  Created by Natalia Consonni on 1/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class User {
    
    var name: String!
    var uid: String!
    
    static let instance: User = User()
    
    init(_ name: String, _ uid: String) {
        self.name = name
        self.uid = uid
    }
    
    init() {}
}
