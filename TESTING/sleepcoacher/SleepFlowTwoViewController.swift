//
//  SleepFlowTwoViewController.swift
//  sleepcoacher
//
//  Created by angel cheung on 11/27/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation
import Alamofire
import SwiftyJSON
import AVFoundation
import ResearchKit

class SleepFlowTwoViewController: UIViewController {
    
    @IBOutlet weak var smiley1: UIButton!
    @IBOutlet weak var smiley2: UIButton!
    @IBOutlet weak var smiley3: UIButton!
    @IBOutlet weak var smiley4: UIButton!
    @IBOutlet weak var smiley5: UIButton!
    
    @IBOutlet weak var eveningQuestionLabel: UILabel!
    @IBOutlet weak var eveningQuestionYesButton: UIButton!
    @IBOutlet weak var eveningQuestionNoButton: UIButton!
    
    var currRating = 0
    var adherence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let experiments = db.experiment
        let experimentArray = experiments[currUser.currentExperiment]
        print(currUser.currentExperiment)
        let experimentQuestionTime = experimentArray![0]
        print(experimentQuestionTime)
        if (experimentQuestionTime == "evening") {
            let experimentQuestion = experimentArray![1]
            eveningQuestionLabel.text = experimentQuestion
        }
        else {
            eveningQuestionLabel.text = ""
            eveningQuestionYesButton.isHidden = true
            eveningQuestionNoButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adherence response
    @IBAction func adherenceYes(_ sender: Any) {
        adherence = "yes"
        eveningQuestionYesButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        eveningQuestionNoButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func adherenceNo(_ sender: Any) {
        adherence = "no"
        eveningQuestionNoButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        eveningQuestionYesButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    // Smiley set ratings
    @IBAction func onSmiley1Pressed(_ sender: Any) {
        currRating = 1
        smiley1.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        smiley2.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5.backgroundColor = UIColor(white: 1, alpha: 0)
    }

    @IBAction func onSmiley2Pressed(_ sender: Any) {
        currRating = 2
        smiley2.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        smiley1.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func onSmiley3Pressed(_ sender: Any) {
        currRating = 3
        smiley3.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        smiley1.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func onSmiley4pressed(_ sender: Any) {
        currRating = 4
        smiley4.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        smiley1.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func onSmiley5Pressed(_ sender: Any) {
        currRating = 5
        smiley5.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        smiley2.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley1.backgroundColor = UIColor(white: 1, alpha: 0)
    }

    @IBAction func onContinuePressed(_ sender: Any) {
        sleepData.adherence = adherence
        sleepData.beforeRating = currRating
    }
}
