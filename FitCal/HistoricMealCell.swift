//
//  HistoricMealCellTableViewCell.swift
//  FitCal
//
//  Created by Natalia Consonni on 12/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit

class HistoricMealCell: UITableViewCell {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var checkIcon: UILabel!
    
    var check: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkIcon.isHidden = true
        checkIcon.text = "\u{2714}"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
