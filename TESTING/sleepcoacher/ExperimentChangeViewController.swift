//
//  ExperimentChangeViewController.swift
//  sleepcoacher
//
//  Created by Angel Cheung on 12/8/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import Alamofire

class ExperimentChangeViewController: UIViewController {
    
    var cancelReason = ""
    var newGoal = ""
    
    @IBOutlet weak var cancelReason1: UIButton!
    @IBOutlet weak var cancelReason2: UIButton!
    @IBOutlet weak var cancelReason3: UIButton!
    @IBOutlet weak var cancelReason4: UIButton!
    @IBOutlet weak var cancelReason5: UIButton!
    @IBOutlet weak var cancelReason6: UIButton!
    var cancelReasonButtons: [UIButton] = [UIButton]()

    @IBOutlet weak var newGoal1: UIButton!
    @IBOutlet weak var newGoal2: UIButton!
    @IBOutlet weak var newGoal3: UIButton!
    var newGoalButtons: [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelReasonButtons = [cancelReason1, cancelReason2, cancelReason3, cancelReason4, cancelReason5, cancelReason6]
        newGoalButtons = [newGoal1, newGoal2, newGoal3]
    }
    
    // Sets a button to look selected given an array of buttons and a label
    func setSelected(buttons:[UIButton], label:String) {
        for button in buttons {
            if (button.currentTitle! == label) {
                button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
            }
            else {
                button.backgroundColor = UIColor(white: 1, alpha: 0)
            }
        }
    }
    
    @IBAction func onCancelReason1Select(_ sender: Any) {
        cancelReason = cancelReason1.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onCancelReason2Select(_ sender: Any) {
        cancelReason = cancelReason2.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onCancelReason3Select(_ sender: Any) {
        cancelReason = cancelReason3.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onCancelReason4Select(_ sender: Any) {
        cancelReason = cancelReason4.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onCancelReason5Select(_ sender: Any) {
        cancelReason = cancelReason5.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onCancelReason6Select(_ sender: Any) {
        cancelReason = cancelReason6.currentTitle!
        setSelected(buttons: cancelReasonButtons, label: cancelReason)
    }
    @IBAction func onNewGoal1Select(_ sender: Any) {
        newGoal = newGoal1.currentTitle!
        setSelected(buttons: newGoalButtons, label: newGoal)
    }
    @IBAction func onNewGoal2Select(_ sender: Any) {
        newGoal = newGoal2.currentTitle!
        setSelected(buttons: newGoalButtons, label: newGoal)
    }
    @IBAction func onNewGoal3Select(_ sender: Any) {
        newGoal = newGoal3.currentTitle!
        setSelected(buttons: newGoalButtons, label: newGoal)
    }
    
    @IBAction func onConfirmExperimentChange(_ sender: Any) {
        let date = Date()
        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
        let newExperiment = currUser.newExperiment
        let userID = currUser.uuid
        currUser.currentExperiment = newExperiment
        currUser.setDefaultExperiment()
        
        // Post request for cancelReason
        let cancelReasonParams = ["OldExperiment": currUser.currentExperiment, "NewExperiment": newExperiment, "CancelReason": self.cancelReason, "GoogleAccount": userID] as [String : Any];
        let cancelReasonEndpoint = "http://sleep.cs.brown.edu:443/" + userID + "/" + dateString + "/experiment_cancellation"
        Alamofire.request(cancelReasonEndpoint, method: .post, parameters: cancelReasonParams).response { res in
            print(String(describing: res.response?.statusCode))
            currUser.currentExperiment = newExperiment
            currUser.setDefaultExperiment()
            print(currUser.currentExperiment)
        }
        
        // Post request for goal
        let goalParams = ["CurrentExperiment": currUser.currentExperiment, "Goal": self.newGoal, "GoogleAccount": userID] as [String : Any];
        let goalEndpoint = "http://sleep.cs.brown.edu:443/" + userID + "/" + dateString + "/current_experiment"
        Alamofire.request(goalEndpoint, method: .post, parameters: goalParams).response { res in
            print(String(describing: res.response?.statusCode))
            currUser.goal = self.newGoal
            currUser.setDefaultGoal()
        }
    }
}
