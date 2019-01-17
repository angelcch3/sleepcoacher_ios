//
//  ScrollViewController.swift
//  oct21
//
//  Created by Adrienne Tran on 5/16/16.
//  Copyright © 2016 nediyana. All rights reserved.
//

import UIKit
import Foundation

protocol TagTappedDelegate {
    // create delegate methods
    func userDidTapTag(info:NSString)
}

class ScrollViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var tagLateCaffeine: UIButton!
    @IBOutlet weak var tagLateExercise: UIButton!
    @IBOutlet weak var tagLateNap: UIButton!
    @IBOutlet weak var tagEarplugs: UIButton!
    @IBOutlet weak var tagMeditate: UIButton!
    @IBOutlet weak var tagWhiteNoise: UIButton!
    
    // create a variable that will recieve / send messages
    // between the view controllers.
    var delegate : TagTappedDelegate? = nil
    
    
    //MARK: Actions
   
    @IBAction func tagLateCaffeinePopulate(_ sender: UIButton) {
        sendTag(info: "#lateCaffeine")
        print("sentTag in func")
    }
    
    
    @IBAction func tagLateExercisePopulate(_ sender: UIButton) {
        sendTag(info: "#lateExercise")
        print("sentTag in func exercise")
    }
    
    @IBAction func tagLateNapPopulate(_ sender: UIButton) {
        sendTag(info: "#lateNap")
        print("sentTag in func nap")
    }
    
    @IBAction func tagEarplugs(_ sender: UIButton) {
        sendTag(info: "#earplugs")
        print("sentTag in func earplugs")
    }
   
    
    @IBAction func tagMeditate(_ sender: UIButton) {
        sendTag(info: "#meditate")
        print("sentTag in func meditate")
    }
   
    
    @IBAction func tagWhiteNoise(_ sender: UIButton) {
        sendTag(info: "#whiteNoise")
        print("sentTag in func whitenoise")
    }
    
    
    
    //MARK: Functions
    
    func sendTag(info: NSString){
        print("IN SENDTAG")
        if (delegate != nil){
            // fire delegate methods
            let information:NSString = info
            print("in sendTag")
            delegate!.userDidTapTag(info: information)
            print("after delegate")
            self.navigationController?.popViewController(animated: true) // doublecheck
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
