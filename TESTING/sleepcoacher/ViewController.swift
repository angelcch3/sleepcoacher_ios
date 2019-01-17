//
//  ViewController.swift
//  oct21
//
//  Created by Nediyana Daskalova on 10/21/15.
//  Copyright © 2015 nediyana. All rights reserved.
//
/*
import UIKit
import CoreMotion
import Foundation
import Alamofire
import SwiftyJSON
import AVFoundation
import ResearchKit

var start_date = ""
var end_date = ""

class ViewController: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate, TagTappedDelegate { //#UPGRADE
    
    @IBOutlet weak var summary_button: UIButton!
    
    // MARK: Rating and tags variables
    @IBOutlet weak var sleepRatinglabel: UILabel!
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet var label: UILabel! // label that shows status
    @IBOutlet weak var smiley1button: UIButton!
    @IBOutlet weak var smiley2button: UIButton!
    @IBOutlet weak var smiley3button: UIButton!
    @IBOutlet weak var smiley4button: UIButton!
    @IBOutlet weak var smiley5button: UIButton!
    var smileyRating: Int = 0
    
    @IBOutlet weak var eveningQuestionLabel: UILabel!
    @IBOutlet weak var eveningQuestion: UILabel!
    @IBOutlet weak var morningQuestion: UILabel!
    
    // Start of adding these on NOV 11 to delete files from device
    var soundPath = ""
    var soundURL: URL!
    var soundOriginPath = ""
    var accelOriginPath = ""
    var sent_response = ""
    var is_it_true = false
    // end of addig these on Nov 11 to delete files from device
    
    // MARK: Server var
    let userID = UIDevice.current.identifierForVendor!.uuidString
    //var postsEndpoint: String = "http://162.243.187.68:443"
    var postsEndpoint: String = "http://sleep.cs.brown.edu:443"
    let dir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as URL!
    var PATH_STRING = ""
    var fileurl:URL?
    
    
    // MARK: Record motion and audio variables
    let motionManager: CMMotionManager = CMMotionManager()
    let accelData: CMAccelerometerData = CMAccelerometerData()
    var recordedAudio: RecordedAudio!
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var recordedDecibelArray = [Float]() // this is only printed later, NEVER USED
    var recordedDateTimeArray = [Date]() // this is only printed later, NEVER USED
    var content = ""
    var power: Float = 0.0
    var prevPower: Float = 0.0
    var timer = Timer()
    var timer_running = false
    var isStart = false
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            // Interruption began, take appropriate actions
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                } else {
                    // Interruption Ended - playback should NOT resume
                }
            }
        }
    }

    

    
    // Actions for tags and rating
    
    func delete_func(){
        
        do {
            // NOW DELETE ACCELEROMETER FILE NOV 10
            
            print("ABOUT TO DELETE accelerationFILE FILE", self.fileurl!.path)
            //NSLog("about to delete ACCELERATIONFILE file", self.fileurl!.path)
            
            // list all the files currently in the directory
            let filelist2 = try FileManager.default.contentsOfDirectory(atPath: accelOriginPath)
            
            for filename in filelist2 {
                print(filename)
            }
            
            if FileManager.default.fileExists(atPath: self.fileurl!.path) {
                do {
                    print("IN DELETE ACCELERATIONFILE", soundURL)
                    // NSLog("IN DELETE ACCELERATIONFILE", soundURL)
                    
                    try FileManager.default.removeItem(at: self.fileurl!)
                    print("DELETED ACCELERATION", self.fileurl!)
                    //NSLog("DELETED ACCELERATION", "\(self.fileurl!)")
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            // list all the files currently in the directory
            // should be none (or at least minus the one that was just created)
            let filelist3 = try FileManager.default.contentsOfDirectory(atPath: accelOriginPath)
            
            for filename in filelist3 {
                print(filename)
            }
            
            // END OF DELETE FILE NOV 10
            
            
            // NOW DELETE AUDIO FILE NOV 11
            
            print("ABOUT TO DELETE AUDIO FILE", soundPath)
            ///NSLog("about to delete audio file", soundPath)
            
            // list all the files currently in the directory
            let filelist = try FileManager.default.contentsOfDirectory(atPath: soundOriginPath)
            
            for filename in filelist {
                print(filename)
            }
            
            
            if FileManager.default.fileExists(atPath: soundPath) {
                do {
                    print("IN DELETE AUDIO", soundURL)
                    //NSLog("IN DELETE AUDIO", soundURL)
                    //try FileManager.default.removeItem(at: soundURL)
                    for filename in filelist {
                        let filepathtoberemoved =  [soundOriginPath, filename]
                        try FileManager.default.removeItem(at: NSURL.fileURL(withPathComponents: filepathtoberemoved)!)
                    }
                    print("DELETED AUDIO", soundURL)
                    // NSLog("DELETED AUDIO", soundURL)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            
            // END OF DELETE AUDIO fFILE NOV 11
            
            // list all the files currently in the directory
            // should be none (or at least minus the one that was just created)
            let filelist1 = try FileManager.default.contentsOfDirectory(atPath: soundOriginPath)
            
            for filename in filelist1 {
                print(filename)
            }
        }
        catch {
            print("some error")
        }
    }
    
    func userDidTapTag(info: NSString) {
        print("IN USERDIDTAPTAG") //this one only gets called when the user is entering a new tag in the text field.
        let curText : String? = tagTextField.text
        tagTextField.text = curText! + (info as String) + " "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("IN PREPARE SEGUE")
        if segue.identifier == "showSecondVC"{
            let secondVC:ScrollViewController = segue.destination as! ScrollViewController
            secondVC.delegate = self
        }
        else if segue.identifier == "summarysegue1"{
            print("in SUMMARYSEGUE1")
            print(start_date)
            let SleepSummaryViewController:SleepSummaryViewController = segue.destination as! SleepSummaryViewController
            //SleepSummaryViewController.delegate = self
            SleepSummaryViewController.bedtime_stamp = start_date
            SleepSummaryViewController.waketime_stamp = end_date
        }
        //var DestViewController: SleepSummaryViewController = segue.summarysegue1 as SleepSummaryViewController
      //  DestViewController.bedtime_label = start_timestamp
        
    }
    

    
    @IBAction func smiley1(_ sender: UIButton) {
        print("smiley 1")
        smiley1button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        
        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
        smileyRating = 1
    }
    
    @IBAction func smiley2(_ sender: UIButton) {
        print("smiley 2")
        smiley2button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        
        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
        smileyRating = 2
    }
    
    @IBAction func smiley3(_ sender: UIButton) {
        print("smiley 3")
        smiley3button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        
        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
        smileyRating = 3
    }
    @IBAction func smiley4(_ sender: UIButton) {
        print("smiley 4")
        smiley4button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        
        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
        smileyRating = 4
    }
    
    @IBAction func smiley5(_ sender: UIButton) {
        print("smiley 5")
        smiley5button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
        
        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
        smileyRating = 5
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ tagTextField: UITextField) -> Bool {
        print("IN TEXTFIELDSHOULDRETURN") //this one also gets called only when use is entering a comment in the text field, and this returns the view.
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Start/Stop
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.sayHello), userInfo: nil, repeats: true)
    }
    
    var start_timestamp = ""

    
    func start(){
        print("inside start")
        
        label.text = "started tracking"
        if label.text == "started tracking" {
            summary_button.isHidden = true
        }
        sleepRatinglabel.text = "Sleep Rating" // revise from "saved rating"
        
        let date = Date()
        start_date = "\(date)"
        // may be problematic in the future we are fixing the int overflow problem in a janky way
        let x = floor(date.timeIntervalSince1970*1000)
        print(x)
        print(Int64(x))
        
        // might want to write an extension to avoid overflow
        let stamp = Int64(floor(date.timeIntervalSince1970*1000))
        start_timestamp = "\(stamp)"
        let timestamp_name = "\(stamp)"
        fileurl = self.dir.appendingPathComponent(timestamp_name)
        accelOriginPath = dir.path
        
        if timer_running == false {
            startTimer()
            timer_running = true
            soundSetup()
        }
        
        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    func stop(){
        motionManager.stopAccelerometerUpdates()
        
        //        Alamofire.request(.GET, postsEndpoint).responseJSON { # UPGRADE TO LINE BELOW
        Alamofire.request(postsEndpoint, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                NSLog("in GET REQUEST")
                let jsonDic = response.result.value as! NSDictionary
                let responseData = jsonDic["responseData"] as! NSDictionary
            }
        }
        
        timer.invalidate()
        timer_running = false
        
        // stop audio recording
        print("stopped recording")
        print("recordedDecibelArray 2 \(recordedDecibelArray)")
        print("recordedDateTimeArray 2 \(recordedDateTimeArray)")
        
        audioRecorder.stop()
        
        // wait for confirmation from server
        // post recordDecibelArray to server
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
        
        // Rating related
        sleepRatinglabel.text = "Saved rating" // edit label text to let user know being saved
        var rating: String
        var tags: String
        rating = String(smileyRating)
        tags = tagTextField.text!
        print("TAGS ARE")
        print(tags)
        
        // send the rating to server
        // WRITE TO FILE //
        let stringToWrite  = "Rating: " + rating + ",Tags:" + tags
        NSLog(stringToWrite)
        let dataToWrite = stringToWrite.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        
        if FileManager.default.fileExists(atPath: self.fileurl!.path) {
            var err:NSError?
            do {
                let fileHandle = try FileHandle(forWritingTo: self.fileurl!)
                fileHandle.seekToEndOfFile()
                fileHandle.write(dataToWrite)
                NSLog("in writing to FILE")
                let datastring = NSString(data: dataToWrite, encoding: String.Encoding.utf8.rawValue ) as! String // from http://stackoverflow.com/questions/24023253/how-to-initialise-a-string-from-nsdata-in-swift
                NSLog(datastring)
                NSLog("DONE WRITING TO FILE")
                fileHandle.closeFile()
                
            } catch let error as NSError {
                err = error
                print("Can't open fileHandle \(err)", terminator: "")
            }
        } else {
            var err:NSError?
            do {
                try dataToWrite.write(to: self.fileurl!, options: .atomic)
            } catch let error as NSError {
                err = error
                print("Can't write \(err)", terminator: "")
            }
        }
        
        // END WRITE TO FILE //
        
        label.text = "stopped tracking"
        if label.text == "stopped tracking" {
            summary_button.isHidden = false
        }
        // send data to server
        // START OF READ FROM FILE ///
        NSLog("START READ OF FILE")
        
        if Reachability.isConnectedToNetwork() == true {
            
            do {
                let readFile = try String(contentsOfFile: PATH_STRING, encoding: String.Encoding.utf8)
                let date = Date()
                end_date = "\(date)"
                let stamp = Int64(floor(date.timeIntervalSince1970*1000))
                let timestmp = "\(stamp)" + ","
                var data_file = self.userID + "," + timestmp
                data_file = data_file + readFile
                let upload_params = ["User": self.userID, "Start_Date": start_timestamp, "End_Date": timestmp, "\nData": readFile]
                // POST REQUEST START
                //                Alamofire.request(.POST, "http://sleep.cs.brown.edu:443" , parameters: upload_params).response { res in
                //                    NSLog("IN POST REUQUEST STOP BUTTON")
                //                    print(res)
                //                } # UPGRADE TO CODE BELOW based on http://stackoverflow.com/questions/39490839/alamofire-swift-3-0-extra-parameter-in-call
                
                Alamofire.request("http://sleep.cs.brown.edu:443", method: .post, parameters: upload_params).response { res in
                    NSLog("IN POST REUQUEST STOP BUTTON")
                    self.sent_response = String(describing: res.response?.statusCode)
                    self.is_it_true = ("Optional(200)"==self.sent_response)
                    print(self.is_it_true)
                    print(self.sent_response)
                    if self.is_it_true == true {
                        self.delete_func()
                    }
                }
                
                
                
                // POST REQUEST END
                //NSLog("\(readFile)")
                
                
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
    
    @IBAction func startTracking(_ sender: Any) {
        isStart = true
        start()
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        isStart = false
        stop()
    }
    
    
    // MARK: Meat
    
    enum DecibelError : Error{
        case youAreNotDoingYourJob
    }
    
    func calculateDecibel() throws{
        print("inside calculate decibel")
        audioRecorder.updateMeters()
        //        let numberOfChannels: Int = 2
        //        var power: Float = 0.0
        NSLog(String(format:"A decibelLevel = %.2f", power));
        
        NSLog(String(format:"B decibelLevel = %.2f", power));
        
        // average of the two channels
        power = audioRecorder.averagePower(forChannel: 0)
        
        NSLog(String(format:"C decibelLevel = %.2f", power));
        
        if (power <= -160.0 && power >= 160.0){
            print("decibel error is not in threshold")
            throw DecibelError.youAreNotDoingYourJob
        }
        
        if (prevPower == power){
            print("* * * * * * * prevPower == power * * * * * * * ")
            throw DecibelError.youAreNotDoingYourJob
        }
        power = audioRecorder.averagePower(forChannel: 0)
        prevPower = power
        
    }
    
    
    // every time the NStimer fires, run this
    func updateSound(_ dateString: Int64){
        print("- - - - - - inside updateSound")
        do {
            try calculateDecibel()
            NSLog(String(format:"power after calculate decibel decibelLevel = %.2f", power));
        } catch DecibelError.youAreNotDoingYourJob{
            print("* * * * * * * Decibel is not doing it's job * * * * * *")
            stop()
            start()
            print("stop / start")
        } catch{
            print("i dunno")
        }
        
        let date = Date()
        print("stop point 1")
        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
        print("stop point 2")
        let paramString = ["Timestamp": dateString, "decibelLevel": power] as [String : Any];//, "ID_number": self.userID];
        print("stop point 3")
        
        
        // WRITE TO FILE //
        // COMMENTED OUT ON JAN 12, to try to make a new text file with each new timestamp.
        print("fileurl")
        print(fileurl)
        let pathString: String = fileurl!.path
        print(pathString)
        // convert to string for reading from file
        
        print("stop point 4")
        PATH_STRING = pathString
        print("stop point 5")
        var stringNoise = ""
        print("stop point 6")
        let powerString = String(format:"%.2f", power)
        print("stop point 7")
        stringNoise = "Timestamp: " + dateString + ","
        stringNoise = stringNoise + "decibelLevel:" + powerString
        stringNoise = stringNoise + ";"
        print("stop point 8")
        
        NSLog(stringNoise)
        let dataToWrite = stringNoise.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        print("stop point 9")
        if FileManager.default.fileExists(atPath: fileurl!.path) {
            print("stop point 10")
            var err:NSError?
            do {
                let fileHandle = try FileHandle(forWritingTo: fileurl!)
                fileHandle.seekToEndOfFile()
                fileHandle.write(dataToWrite)
                NSLog("in writing to FILE")
                let datastring = NSString(data: dataToWrite, encoding: String.Encoding.utf8.rawValue ) as! String
                NSLog(datastring)
                NSLog("DONE WRITING TO FILE")
                fileHandle.closeFile()
                
            } catch let error as NSError {
                err = error
                print("Can't open fileHandle \(err)", terminator: "")
            }
        }
        else {
            print("stop point 11")
            var err:NSError?
            do {
                try dataToWrite.write(to: fileurl!, options: .atomic)
            } catch let error as NSError {
                err = error
                print("Can't write \(err)", terminator: "")
            }
        }
        return
    }
    
    
    
    func sayHello()
    {
        motionManager.accelerometerUpdateInterval = 1 //1 time per second
        
        let date = Date()
        let stamp = Int64(floor(date.timeIntervalSince1970*1000))
        
        var acceleration_xyz = 0.0;
        var acceleration_x = 0.0;
        var acceleration_y = 0.0;
        var acceleration_z = 0.0;
        
        updateSound(stamp);
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
            [weak self] (data: CMAccelerometerData?, error: Error?) in self!.label.text = "started tracking"
            // fixed error on nov 9 thanks to http://stackoverflow.com/questions/39373411/swift-2-to-swift-3-0-motionmanager
            
            acceleration_x =  data!.acceleration.x
            acceleration_y =  data!.acceleration.y
            acceleration_z =  data!.acceleration.z
            
            NSLog(String(format:"%.2f", acceleration_x));
            NSLog(String(format:"%.2f", acceleration_y));
            NSLog(String(format:"%.2f", acceleration_z));
            
            // this adds up the accelerations over all 3 axes, but if the phone us just staying stright vertically (with charging port pointing down, and screen pointing towards user while holding phone, then the y axis = -0.99, so this adds up to a high value again; maybe check that?
            acceleration_xyz = fabs(acceleration_x) + fabs(acceleration_y) + fabs(acceleration_z) //CHANGE METRICS HERE!!!
            
            //CODE FROM MEMO
            
            //var alpha = 0.8
            //var g1 = alpha * g1 + (1 - alpha) * acceleration_x;
            //var g2 = alpha * g2 + (1 - alpha) * acceleration_y;
            //var g3 = alpha * g3 + (1 - alpha) * acceleration_z;
            
            //var x = Math.abs(acceleration_x - g1);
            //var y = Math.abs(acceleration_y - g2);
            //var z = Math.abs(acceleration_z - g3);"
            
            //accelerometer_new = x + y + z;
            
            
            //CODE FROM DOPPLESLEEP
//            var x = acceleration_x*acceleration_x
//            var y = acceleration_y*acceleration_y
//            var z = acceleration_z*acceleration_z
            
//            var accelerometer_new = sqrt(x+y+z)
            
//            print("accelerometer_new")
//            print(accelerometer_new)
            
            NSLog("combined")
            NSLog(String(format:"%.2f", acceleration_xyz));
            
            let string1 = String(format: "%.2f\n", acceleration_xyz)
            
            
            if let dataFromString = string1.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                NSLog(String(stringInterpolationSegment: json))
            }
            
            var acceleration_data = ""
            var timestmp = ""
            acceleration_data = string1
            timestmp = "\(stamp)" + ","
            let newPostStamp = ["Timestamp": timestmp, "accelerometer": acceleration_data];//, "ID_number": self!.userID];
            let tempData = timestmp + acceleration_data + "\(self!.userID)"
            let data1 = tempData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            let pathString: String = self!.fileurl!.path // convert to string for reading from file
            self!.PATH_STRING = pathString
            
            
            // WRITE TO FILE //
            acceleration_data = acceleration_data+";"
            let stringToWrite  = "Timestamp: " + timestmp + "acceleormeter: " + acceleration_data// + "ID_number: " + self!.userID
            NSLog(stringToWrite)
            let dataToWrite = stringToWrite.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            
            // self!.fileurl! should be just fileurl
            if FileManager.default.fileExists(atPath: self!.fileurl!.path) {
                var err:NSError?
                do {
                    // self!.fileurl! should be just fileurl
                    let fileHandle = try FileHandle(forWritingTo: self!.fileurl!)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(dataToWrite)
                    NSLog("in writing to FILE")
                    let datastring = NSString(data: dataToWrite, encoding: String.Encoding.utf8.rawValue ) as! String
                    NSLog(datastring)
                    NSLog("DONE WRITING TO FILE")
                    fileHandle.closeFile()
                    
                } catch let error as NSError {
                    err = error
                    print("Can't open fileHandle \(err)", terminator: "")
                }
            } else {
                var err:NSError?
                // self!.fileurl! should be just fileurl
                do {
                    try dataToWrite.write(to: self!.fileurl!, options: .atomic)
                } catch let error as NSError {
                    err = error
                    print("Can't write \(err)", terminator: "")
                }
            }
            
        }
    }
    
    func soundSetup(){
        print("recording sound")
        
        // save audio file (deprecate for now)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        soundURL = filePath
        soundPath = pathArray[0]
        soundOriginPath = dirPath
        let nullURL = NSURL.fileURL(withPath: "dev/null")
        
        
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        queue.async(execute: {[weak self] in
            
            // create an AudioSession
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.mixWithOthers)
            } catch _ {
                print("error with audio session")
            }
            
            self!.setupNotifications()

            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            //http://www.vishalvirodhia.com/recording-audio-using-avaudiorecorder-swift-2-1.html
            // create a new audio recorder
            self!.audioRecorder = try? AVAudioRecorder(url: filePath!, settings: [:]) //if we change filePath! to be nullURL, then the app breaks -- it goes into the decibel level =-160 command so it restarts, so there is a new csv uploaded for every timestamp.
            self!.audioRecorder.delegate = self
            self!.audioRecorder.isMeteringEnabled = true
            self!.audioRecorder.prepareToRecord()
            self!.audioRecorder.record()
            
        })
    
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: .AVAudioSessionInterruption,
                                       object: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CURR USER: CURRENT EXPERIMENT")
        print(currUser.currentExperiment)
        let experiments = db.experiment
        let experimentArray = experiments[currUser.currentExperiment]
        eveningQuestionLabel.text = experimentArray![1]
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            // Terms have been accepted, proceed as normal
            print("proceed VIEW CONTROLLER")
//            performSegue(withIdentifier: "proceedsegue", sender: self)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myViewController = self
            
            // Handle the text field's user input (closes keyboard when taps "return"
            print("IN DELEGATE")
            self.tagTextField.delegate = self
            
        } else {
            // Terms have not been accepted. Show terms (perhaps using performSegueWithIdentifier)
            print("TERMS VIEW CONTROLLER")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "termssegue", sender: self)
                print("should have changed views!")
            }
            
        
        
    }
    
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording - (1) phone call or (2) STOPPED")
        print("iOS has stopped recording")
        
        if (flag){
            // store in model
            recordedAudio = RecordedAudio()
            recordedAudio.title = recorder.url.lastPathComponent
        } else{
            print("recording not successful")
        }
    }
    
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        print("* * * * * * * inside end interruption")
        if flags == AVAudioSessionInterruptionFlags_ShouldResume{
            print("inside end interruption2")
        }
    }
}


    
//    @IBAction func surveyTapped(sender : AnyObject) {
//        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
//        taskViewController.delegate = self
//        present(taskViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func microphoneTapped(sender : AnyObject) {
//        let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRun: nil)
//        taskViewController.delegate = self
//        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! String, isDirectory: true) as URL
//        present(taskViewController, animated: true, completion: nil)
//    }
    
}
*/



