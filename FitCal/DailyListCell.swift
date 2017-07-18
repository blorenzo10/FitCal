//
//  DailyListCell.swift
//  FitCal
//
//  Created by Natalia Consonni on 22/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit

class DailyListCell: UITableViewCell {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealCalLabel: UILabel!
    @IBOutlet weak var mealMacroLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
