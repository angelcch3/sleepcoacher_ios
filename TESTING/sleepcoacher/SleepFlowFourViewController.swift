//
//  SleepFlowFourViewController.swift
//  sleepcoacher
//
//  Created by angel cheung on 11/29/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import Alamofire

class SleepFlowFourViewController: UIViewController, UITextFieldDelegate {
    
    var currRating = 0
    var adherence = ""
    var disruption = ""
    var experimentQuestionNeeded = false
    
    @IBOutlet weak var smiley1: UIButton!
    @IBOutlet weak var smiley2: UIButton!
    @IBOutlet weak var smiley3: UIButton!
    @IBOutlet weak var smiley4: UIButton!
    @IBOutlet weak var smiley5: UIButton!
    
    @IBOutlet weak var morningQuestionLabel: UILabel!
    @IBOutlet weak var morningQuestionYesButton: UIButton!
    @IBOutlet weak var morningQuestionNoButton: UIButton!
    
    @IBOutlet weak var disruptionYesButton: UIButton!
    @IBOutlet weak var disruptionNoButton: UIButton!
    @IBOutlet weak var disruptionTextField: UITextField!
    
    var accelOriginPath = ""
    var soundOriginPath = ""
    var fileurl:URL?
    var soundPath = ""
    
    var response = ""
    var responseSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let experiments = db.experiment
        let experimentArray = experiments[currUser.currentExperiment]
        let experimentQuestionTime = experimentArray![0]
        print(experimentQuestionTime)
        if (experimentQuestionTime == "morning") {
            experimentQuestionNeeded = true
            let experimentQuestion = experimentArray![1]
            morningQuestionLabel.text = experimentQuestion
        }
        else {
            morningQuestionLabel.text = ""
            morningQuestionYesButton.isHidden = true
            morningQuestionNoButton.isHidden = true
        }
        accelOriginPath = sleepData.accelOriginPath
        soundOriginPath = sleepData.soundOriginPath
        fileurl = sleepData.fileurl
        soundPath = sleepData.soundPath
        self.disruptionTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ tagTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adherenceYes(_ sender: Any) {
        adherence = "yes"
        morningQuestionYesButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        morningQuestionNoButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func adherenceNo(_ sender: Any) {
        adherence = "no"
        morningQuestionNoButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        morningQuestionYesButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func disruptionYes(_ sender: Any) {
        disruption = "yes"
        disruptionYesButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        disruptionNoButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    @IBAction func disruptionNo(_ sender: Any) {
        disruption = "no"
        disruptionNoButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        disruptionYesButton.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
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
    
    @IBAction func onSmiley4Pressed(_ sender: Any) {
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
    
    @IBAction func onFinishPressed(_ sender: Any) {
        sleepData.afterRating = currRating
        if (experimentQuestionNeeded) {
            sleepData.adherence = adherence
        }
        sleepData.disruptions = disruption
        print(sleepData.filePath)
        print(sleepData.tags)
        print(sleepData.beforeRating)
        print(sleepData.afterRating)
        sendSleepData()
    }
    
    func sendSleepData() {
        if Reachability.isConnectedToNetwork() == true {
            
            do {
                let readFile = try String(contentsOfFile: sleepData.filePath, encoding: String.Encoding.utf8)
                let date = Date()
                let stamp = Int64(floor(date.timeIntervalSince1970*1000))
                let currentTimestamp = "\(stamp)" + ","
                let disruptionText : String? = disruptionTextField.text

                let upload_params = ["User": currUser.uuid, "Start_Date": sleepData.startTimestamp, "End_Date": currentTimestamp, "StartRating": sleepData.beforeRating, "Tags": sleepData.tags, "StopRating": sleepData.afterRating, "Adherence": sleepData.adherence, "Disruptions": sleepData.disruptions, "DisruptionDetails": disruptionText!, "Timezone": currUser.timezone, "\nData": readFile] as [String : Any]
                print(upload_params)

                Alamofire.request("http://sleep.cs.brown.edu:443", method: .post, parameters: upload_params).response { res in
                    NSLog("IN POST REUQUEST STOP BUTTON")
                    self.response = String(describing: res.response?.statusCode)
                    self.responseSuccess = ("Optional(200)" == self.response)
                    print(self.response)
                    print(self.responseSuccess)
                    // check for reachability check, save debug log to file on phone
                    if (self.responseSuccess == true) {
                        self.delete_func()
                    }
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
        else {
            NSLog("NO INTERNET")
            // check periodically for internet and upload data then!
            // NSTimer to check for wifi exponentially?
        }
    }
    
    func delete_func() {
        do {
            let filelist2 = try FileManager.default.contentsOfDirectory(atPath: accelOriginPath)
            
            if FileManager.default.fileExists(atPath: fileurl!.path) {
                do {
                    try FileManager.default.removeItem(at: fileurl!)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            let filelist3 = try FileManager.default.contentsOfDirectory(atPath: accelOriginPath)
            
            let filelist = try FileManager.default.contentsOfDirectory(atPath: soundOriginPath)
            
            if FileManager.default.fileExists(atPath: soundPath) {
                do {
                    for filename in filelist {
                        let filepathtoberemoved =  [soundOriginPath, filename]
                        try FileManager.default.removeItem(at: NSURL.fileURL(withPathComponents: filepathtoberemoved)!)
                    }
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            let filelist1 = try FileManager.default.contentsOfDirectory(atPath: soundOriginPath)
        }
        catch {
            print("some error")
        }
    }
}
