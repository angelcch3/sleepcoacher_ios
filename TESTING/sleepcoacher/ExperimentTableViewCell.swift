//
//  ExperimentTableViewCell.swift
//  sleepcoacher
//
//  Created by angel cheung on 10/25/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import Alamofire

class ExperimentTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func selectExperiment(_ sender: Any) {
       currUser.newExperiment = label.currentTitle!
        print(currUser.newExperiment)
    }

    // Set row selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
