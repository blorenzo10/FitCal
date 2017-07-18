//
//  Utils.swift
//  FitCal
//
//  Created by Natalia Consonni on 3/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import Foundation

class Utils {
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: currentDate)
    }
}
