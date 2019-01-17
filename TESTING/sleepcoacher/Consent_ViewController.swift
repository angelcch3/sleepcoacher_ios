//
//  Consent_ViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/25/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//

import Foundation
import ResearchKit

extension ConsentViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func consentTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
}
