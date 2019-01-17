//
//  SleepFlowOneViewController.swift
//  sleepcoacher
//
//  Created by angel cheung on 11/13/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit

class SleepFlowOneViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var currentExperimentLabel: UILabel!
    
    var tags = ""
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            currUser.getDefaultExperiment()
            currUser.getDefaultGoal()
            currentExperimentLabel.text = "Current Experiment: " + currUser.currentExperiment
            print("sleepFlowOne will appear")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            // Terms have been accepted, proceed as normal
            print("proceed VIEW CONTROLLER")
            //            performSegue(withIdentifier: "proceedsegue", sender: self)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            currUser.getDefaultExperiment()
            currUser.getDefaultGoal()
            sleepData.reset()
            self.tagTextField.delegate = self
            currentExperimentLabel.text = "Current Experiment: " + currUser.currentExperiment
        } else {
            // Terms have not been accepted. Show terms (perhaps using performSegueWithIdentifier)
            print("TERMS VIEW CONTROLLER")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "termssegue", sender: self)
                print("should have changed views!")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ tagTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func lateNapTagPressed(_ sender: Any) {
        let curText : String? = tagTextField.text
        tagTextField.text = curText! + "#LateNap" + " "
    }
    
    @IBAction func alcoholTagPressed(_ sender: Any) {
        let curText : String? = tagTextField.text
        tagTextField.text = curText! + "#Alcohol" + " "
    }
    
    @IBAction func lateSnackTagPressed(_ sender: Any) {
        let curText : String? = tagTextField.text
        tagTextField.text = curText! + "#LateSnack" + " "
    }
    
    @IBAction func onStartPressed(_ sender: Any) {
        sleepData.tags = tagTextField.text!
    }
}

