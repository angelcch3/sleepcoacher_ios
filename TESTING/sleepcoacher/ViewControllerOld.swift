////
////  ViewController.swift
////  oct21
////
////  Created by Nediyana Daskalova on 10/21/15.
////  Copyright © 2015 nediyana. All rights reserved.
////
//
//import UIKit
//import CoreMotion
//import Foundation
//import Alamofire
//import SwiftyJSON
//import AVFoundation
//
////
////extension NSData { // from http://codereview.stackexchange.com/questions/86611/save-token-id-into-a-database-in-swift/86613#86613 (swift 2 at the bottom)
////    var hexString: String {
////        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
////        return bytes.map { String(format: "%02hhx", $0) }.reduce("", combine: { $0 + $1 })
////    }
////}
////
//class ViewControllerOld: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate, TagTappedDelegate {
//    
//    
//    // MARK: Rating and tags variables
//    @IBOutlet weak var sleepRatinglabel: UILabel!
//    @IBOutlet weak var tagTextField: UITextField!
//    @IBOutlet var label: UILabel! // label that shows status
//    @IBOutlet weak var smiley1button: UIButton!
//    @IBOutlet weak var smiley2button: UIButton!
//    @IBOutlet weak var smiley3button: UIButton!
//    @IBOutlet weak var smiley4button: UIButton!
//    @IBOutlet weak var smiley5button: UIButton!
//    var smileyRating: Int = 0
//    
//    
//    
//    // MARK: Other var
//    
//    @IBOutlet weak var startButtonLabel: UIButton!
//    
//    let motionManager: CMMotionManager = CMMotionManager()
//    let accelData: CMAccelerometerData = CMAccelerometerData()
//    
//    let userID = UIDevice.currentDevice().identifierForVendor!.UUIDString
//    var postsEndpoint: String = "http://sleep.cs.brown.edu:80"
//    var recordedAudio: RecordedAudio!
//    var audioRecorder: AVAudioRecorder!
//    var audioSession: AVAudioSession!
//    var recordedDecibelArray = [Float]() // this is only printed later, NEVER USED
//    var recordedDateTimeArray = [NSDate]() // this is only printed later, NEVER USED
//    var timer = NSTimer()
//    var content = ""
//    var power: Float = 0.0
//    var prevPower: Float = 0.0
//    let dir: NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL!
//    var PATH_STRING = ""
//    var fileurl:NSURL?
//    var timer_running = false
//    var isStart = false
//    
//    
//    
//    // Actions
//    
//    func userDidTapTag(info: NSString) {
//        let curText : String? = tagTextField.text
//        tagTextField.text = curText! + (info as String) + " "
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showSecondVC"{
//            let secondVC:ScrollViewController = segue.destinationViewController as! ScrollViewController
//            secondVC.delegate = self
//        }
//    }
//    
//    @IBAction func smiley1(sender: UIButton) {
//        print("smiley 1")
//        smiley1button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
//        
//        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smileyRating = 1
//    }
//    
//    @IBAction func smiley2(sender: UIButton) {
//        print("smiley 2")
//        smiley2button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
//        
//        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smileyRating = 2
//    }
//    
//    @IBAction func smiley3(sender: UIButton) {
//        print("smiley 3")
//        smiley3button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
//        
//        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smileyRating = 3
//    }
//    @IBAction func smiley4(sender: UIButton) {
//        print("smiley 4")
//        smiley4button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
//        
//        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smileyRating = 4
//    }
//    
//    @IBAction func smiley5(sender: UIButton) {
//        print("smiley 5")
//        smiley5button.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
//        
//        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smileyRating = 5
//    }
//    
//    //    @IBAction func setDefaultLabelText(sender: UIButton) {
//    //        sleepRatinglabel.text = "Sleep Rating (1-5)"
//    //    }
//    
//    // MARK: UITextFieldDelegate
//    func textFieldShouldReturn(tagTextField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        //        tagTextField.resignFirstResponder() // Hide the keyboard
//        return false
//    }
//    
//    //    func textFieldDidEndEditing(textField: UITextField) {
//    //        var rating: String
//    //        // read information in the text field and do something with it
//    ////        sleepRatinglabel.text = "Your rating has been saved!"
//    //        print("rating")
//    //        print(rating)
//    //    }
//    //
//    
//    
//    // MARK: Start/Stop
//    func startTimer(){
//        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("sayHello"), userInfo: nil, repeats: true)
//    }
//    
//    var start_timestamp = ""
//    
//    
//    func start(){
//        print("inside start")
//        
//        label.text = "started tracking"
//        sleepRatinglabel.text = "Sleep Rating" // revise from "saved rating"
//        
//        let date = NSDate()
//        
//        // may be problematic in the future
//        let x = floor(date.timeIntervalSince1970*1000)
//        print(x)
//        print(Int64(x))
//        //        print(String(x.dynamicType))
//        // might want to write an extension to avoid overflow
//        let stamp = Int64(floor(date.timeIntervalSince1970*1000))
//        start_timestamp = "\(stamp)"
//        let timestamp_name = "\(stamp)"
//        fileurl = self.dir.URLByAppendingPathComponent(timestamp_name)
//        
//        if timer_running == false {
//            //          timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("sayHello"), userInfo: nil, repeats: true)
//            startTimer()
//            timer_running = true
//            soundSetup()
//            
//        }
//        
//        smiley1button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley2button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley3button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley4button.backgroundColor = UIColor(white: 1, alpha: 0)
//        smiley5button.backgroundColor = UIColor(white: 1, alpha: 0)
//    }
//    
//    func stop(){
//        motionManager.stopAccelerometerUpdates()
//        
//        Alamofire.request(.GET, postsEndpoint).responseJSON {
//            response in
//            if response.result.isSuccess{
//                NSLog("in GET REQUEST")
//                let jsonDic = response.result.value as! NSDictionary
//                let responseData = jsonDic["responseData"] as! NSDictionary
//            }
//        }
//        
//        timer.invalidate()
//        timer_running = false
//        
//        // stop audio recording
//        print("stopped recording")
//        print("recordedDecibelArray 2 \(recordedDecibelArray)")
//        print("recordedDateTimeArray 2 \(recordedDateTimeArray)")
//        
//        audioRecorder.stop()
//        
//        // wait for confirmation from server
//        // post recordDecibelArray to server
//        
//        let audioSession = AVAudioSession.sharedInstance()
//        
//        do {
//            try audioSession.setActive(false)
//        } catch _ {
//        }
//        
//        
//        // Rating related
//        sleepRatinglabel.text = "Saved rating" // edit label text to let user know being saved
//        var rating: String
//        var tags: String
//        //        rating = ratingTextField.text! // store the rating
//        rating = String(smileyRating)
//        tags = tagTextField.text!
//        
//        // send the rating to server
//        // WRITE TO FILE //
//        let stringToWrite  = "Rating: " + rating + ",Tags:" + tags
//        NSLog(stringToWrite)
//        let dataToWrite = stringToWrite.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//        
//        
//        // self!.fileurl! should be just fileurl
//        if NSFileManager.defaultManager().fileExistsAtPath(self.fileurl!.path!) {
//            var err:NSError?
//            do {
//                // self!.fileurl! should be just fileurl
//                let fileHandle = try NSFileHandle(forWritingToURL: self.fileurl!)
//                fileHandle.seekToEndOfFile()
//                fileHandle.writeData(dataToWrite)
//                NSLog("in writing to FILE")
//                let datastring = NSString(data: dataToWrite, encoding: NSUTF8StringEncoding ) as! String // from http://stackoverflow.com/questions/24023253/how-to-initialise-a-string-from-nsdata-in-swift
//                NSLog(datastring)
//                NSLog("DONE WRITING TO FILE")
//                fileHandle.closeFile()
//                
//            } catch let error as NSError {
//                err = error
//                print("Can't open fileHandle \(err)", terminator: "")
//            }
//        } else {
//            var err:NSError?
//            // self!.fileurl! should be just fileurl
//            do {
//                try dataToWrite.writeToURL(self.fileurl!, options: .DataWritingAtomic)
//            } catch let error as NSError {
//                err = error
//                print("Can't write \(err)", terminator: "")
//            }
//        }
//        
//        // END WRITE TO FILE //
//        
//        label.text = "stopped tracking"
//        
//        // send data to server
//        // START OF READ FROM FILE ///
//        NSLog("START READ OF FILE")
//        
//        if Reachability.isConnectedToNetwork() == true {
//            
//            do {
//                let readFile = try String(contentsOfFile: PATH_STRING, encoding: NSUTF8StringEncoding)
//                let date = NSDate()
//                let stamp = Int64(floor(date.timeIntervalSince1970*1000))
//                let timestmp = "\(stamp)" + ","
//                var data_file = self.userID + "," + timestmp
//                data_file = data_file + readFile
//                let upload_params = ["User": self.userID, "Start_Date": start_timestamp, "End_Date": timestmp, "\nData": readFile]
//                // POST REQUEST START
//                Alamofire.request(.POST, "http://sleep.cs.brown.edu:80" , parameters: upload_params).response { res in
//                    NSLog("IN POST REUQUEST STOP BUTTON")
//                    print(res)
//                }
//                
//                // POST REQUEST END
//                NSLog("\(readFile)")
//            } catch let error as NSError {
//                print("Error: \(error)")
//            }
//        }
//        else {
//            NSLog("NO INTERNET")
//            // check periodically for internet and upload data then!
//            // NSTimer to check for wifi exponentially?
//        }
//    }
//    
//    @IBAction func startButton(sender: AnyObject) {
//        
//        if isStart == false{ // not started yet -> start
//            isStart = true
//            startButtonLabel.setTitle("Stop", forState: UIControlState.Normal)
//            start()
//        } else{ // already started -> stop
//            isStart = false
//            startButtonLabel.setTitle("Start", forState: UIControlState.Normal)
//            stop()
//        }
//        
//    }
//    
//    //    @IBAction func stopButton(sender: AnyObject) {
//    //        stop()
//    //    }
//    
//    // MARK: Meat
//    
//    enum DecibelError : ErrorType{
//        case YouAreNotDoingYourJob
//    }
//    
//    func calculateDecibel() throws{
//        print("inside calculate decibel")
//        audioRecorder.updateMeters()
//        //        let numberOfChannels: Int = 2
//        //        var power: Float = 0.0
//        NSLog(String(format:"A decibelLevel = %.2f", power));
//        
//        //        for (var i = 0; i < 2; i+=1){
//        //            power += audioRecorder.averagePowerForChannel(i)
//        //        }
//        
//        NSLog(String(format:"B decibelLevel = %.2f", power));
//        // average of the two channels
//        //        power /= Float(numberOfChannels)
//        power = audioRecorder.averagePowerForChannel(0)
//        
//        NSLog(String(format:"C decibelLevel = %.2f", power));
//        
//        if (power <= -160.0 && power >= 160.0){
//            print("decibel error is not in threshold")
//            throw DecibelError.YouAreNotDoingYourJob
//        }
//        
//        if (prevPower == power){
//            print("* * * * * * * prevPower == power * * * * * * * ")
//            throw DecibelError.YouAreNotDoingYourJob
//        }
//        power = audioRecorder.averagePowerForChannel(0)
//        prevPower = power
//        
//    }
//    
//    
//    // every time the NStimer fires, run this
//    func updateSound(dateString: Int64){
//        print("- - - - - - inside updateSound")
//        
//        //
//        //        audioRecorder.updateMeters()
//        //        let numberOfChannels: Int = 2
//        //        var power: Float = 0.0
//        //
//        //        for (var i = 0; i < 2; i+=1){
//        //            power += audioRecorder.averagePowerForChannel(i)
//        //        }
//        //
//        //        // average of the two channels
//        //        power /= Float(numberOfChannels)
//        //
//        do {
//            try calculateDecibel()
//            NSLog(String(format:"power after calculate decibel decibelLevel = %.2f", power));
//        } catch DecibelError.YouAreNotDoingYourJob{
//            print("* * * * * * * Decibel is not doing it's job * * * * * *")
//            //            resetTimer()
//            stop()
//            start()
//            print("stop / start")
//        } catch{
//            print("i dunno")
//        }
//        
//        let date = NSDate()
//        print("stop point 1")
//        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
//        print("stop point 2")
//        let paramString = ["Timestamp": dateString, "decibelLevel": power];//, "ID_number": self.userID];
//        print("stop point 3")
//        
//        //        NSLog(String(format:"decibelLevel = %.2f", power));
//        
//        
//        // WRITE TO FILE //
//        // COMMENTED OUT ON JAN 12, to try to make a new text file with each new timestamp.
//        //        let fileurl = self.dir.URLByAppendingPathComponent("jan12.txt")
//        print("fileurl")
//        print(fileurl)
//        let pathString: String = fileurl!.path!
//        print(pathString)
//        // convert to string for reading from file!! from: http://stackoverflow.com/questions/33510541/how-to-convert-nsurl-to-string-in-swift
//        
//        print("stop point 4")
//        PATH_STRING = pathString
//        print("stop point 5")
//        var stringNoise = ""
//        print("stop point 6")
//        let powerString = String(format:"%.2f", power)
//        print("stop point 7")
//        stringNoise = "Timestamp: " + dateString + ","
//        stringNoise = stringNoise + "decibelLevel:" + powerString
//        stringNoise = stringNoise + ";"
//        print("stop point 8")
//        //stringNoise = stringNoise + "ID_number: " + self.userID
//        
//        NSLog(stringNoise)
//        let dataToWrite = stringNoise.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//        print("stop point 9")
//        if NSFileManager.defaultManager().fileExistsAtPath(fileurl!.path!) {
//            print("stop point 10")
//            var err:NSError?
//            do {
//                let fileHandle = try NSFileHandle(forWritingToURL: fileurl!)
//                fileHandle.seekToEndOfFile()
//                fileHandle.writeData(dataToWrite)
//                NSLog("in writing to FILE")
//                let datastring = NSString(data: dataToWrite, encoding: NSUTF8StringEncoding ) as! String // from http://stackoverflow.com/questions/24023253/how-to-initialise-a-string-from-nsdata-in-swift
//                NSLog(datastring)
//                NSLog("DONE WRITING TO FILE")
//                fileHandle.closeFile()
//                
//            } catch let error as NSError {
//                err = error
//                print("Can't open fileHandle \(err)", terminator: "")
//            }
//        }
//        else {
//            print("stop point 11")
//            var err:NSError?
//            do {
//                try dataToWrite.writeToURL(fileurl!, options: .DataWritingAtomic)
//            } catch let error as NSError {
//                err = error
//                print("Can't write \(err)", terminator: "")
//            }
//        }
//        return
//    }
//    
//    
//    
//    func sayHello()
//    {
//        motionManager.accelerometerUpdateInterval = 1 //1 time per second
//        
//        let date = NSDate()
//        let stamp = Int64(floor(date.timeIntervalSince1970*1000))
//        
//        //timestamp.text = "\(stamp)"
//        
//        var acceleration_xyz = 0.0;
//        var acceleration_x = 0.0;
//        var acceleration_y = 0.0;
//        var acceleration_z = 0.0;
//        
//        updateSound(stamp);
//        
//        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
//            [weak self] (data: CMAccelerometerData?, error: NSError?) in self!.label.text = "started tracking"
//            
//            //                String(format:"%.2f", data!.acceleration.x)
//            
//            acceleration_x =  data!.acceleration.x
//            acceleration_y =  data!.acceleration.y
//            acceleration_z =  data!.acceleration.z
//            
//            NSLog(String(format:"%.2f", acceleration_x));
//            NSLog(String(format:"%.2f", acceleration_y));
//            NSLog(String(format:"%.2f", acceleration_z));
//            // this adds up the accelerations over all 3 axes, but if the phone us just staying stright vertically (with charging port pointing down, and screen pointing towards user while holding phone, then the y axis = -0.99, so this adds up to a high value again; maybe check that?
//            acceleration_xyz = fabs(acceleration_x) + fabs(acceleration_y) + fabs(acceleration_z)
//            NSLog("combined")
//            NSLog(String(format:"%.2f", acceleration_xyz));
//            
//            //            self!.label.text = String(format:"%.2f", acceleration_xyz)
//            let string1 = String(format: "%.2f\n", acceleration_xyz)
//            
//            //            var data1 = string1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//            
//            if let dataFromString = string1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//                let json = JSON(data: dataFromString)
//                NSLog(String(stringInterpolationSegment: json))
//            }
//            
//            var acceleration_data = ""
//            var timestmp = ""
//            acceleration_data = string1
//            timestmp = "\(stamp)" + ","
//            let newPostStamp = ["Timestamp": timestmp, "accelerometer": acceleration_data];//, "ID_number": self!.userID];
//            let tempData = timestmp + acceleration_data + "\(self!.userID)"
//            let data1 = tempData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//            //            NSLog(string1)
//            
//            
//            //            let fileurl = self!.dir.URLByAppendingPathComponent("jan12.txt")
//            // self!.fileurl! should be just fileurl
//            let pathString: String = self!.fileurl!.path! // convert to string for reading from file!! from: http://stackoverflow.com/questions/33510541/how-to-convert-nsurl-to-string-in-swift
//            
//            self!.PATH_STRING = pathString
//            
//            
//            // WRITE TO FILE //
//            acceleration_data = acceleration_data+";"
//            let stringToWrite  = "Timestamp: " + timestmp + "acceleormeter: " + acceleration_data// + "ID_number: " + self!.userID
//            NSLog(stringToWrite)
//            let dataToWrite = stringToWrite.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//            
//            
//            // self!.fileurl! should be just fileurl
//            if NSFileManager.defaultManager().fileExistsAtPath(self!.fileurl!.path!) {
//                var err:NSError?
//                do {
//                    // self!.fileurl! should be just fileurl
//                    let fileHandle = try NSFileHandle(forWritingToURL: self!.fileurl!)
//                    fileHandle.seekToEndOfFile()
//                    fileHandle.writeData(dataToWrite)
//                    NSLog("in writing to FILE")
//                    let datastring = NSString(data: dataToWrite, encoding: NSUTF8StringEncoding ) as! String // from http://stackoverflow.com/questions/24023253/how-to-initialise-a-string-from-nsdata-in-swift
//                    NSLog(datastring)
//                    NSLog("DONE WRITING TO FILE")
//                    fileHandle.closeFile()
//                    
//                } catch let error as NSError {
//                    err = error
//                    print("Can't open fileHandle \(err)", terminator: "")
//                }
//            } else {
//                var err:NSError?
//                // self!.fileurl! should be just fileurl
//                do {
//                    try dataToWrite.writeToURL(self!.fileurl!, options: .DataWritingAtomic)
//                } catch let error as NSError {
//                    err = error
//                    print("Can't write \(err)", terminator: "")
//                }
//            }
//            
//        }
//    }
//    
//    func soundSetup(){
//        print("recording sound")
//        
//        // save audio file (deprecate for now)
//        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
//        let pathArray = [dirPath, recordingName]
//        //        let filePath = NSURL.fileURLWithPathComponents([""])
//        let filePath = NSURL.fileURLWithPathComponents(pathArray)
//        print(filePath)
//        
//        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(queue, {[weak self] in
//            
//            // create an AudioSession
//            let audioSession = AVAudioSession.sharedInstance()
//            do {
//                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
//            } catch _ {
//                print("error with audio session")
//            }
//            
//            NSNotificationCenter.defaultCenter().addObserver(
//                self!,
//                selector: "handleInterruption:",
//                name: AVAudioSessionInterruptionNotification,
//                object: nil)
//            
//            //            try! AVAudioSession.sharedInstance().setActive(true)
//            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
//            
//            // create a new audio recorder
//            self!.audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
//            
//            self!.audioRecorder.delegate = self
//            self!.audioRecorder.meteringEnabled = true
//            self!.audioRecorder.prepareToRecord()
//            self!.audioRecorder.record()
//            
//            })
//        
//    }
//    
//    
//    
//    
//    
//    
//    func handleInterruption(notification: NSNotification){
//        /* Audio Session is interrupted. The player will be paused here */
//        print ("handleInterruption")
//        
//        let interruptionTypeAsObject : AnyObject? =
//            notification.userInfo?[AVAudioSessionInterruptionTypeKey]
//        
//        let interruptionType = AVAudioSessionInterruptionType(rawValue:
//            interruptionTypeAsObject!.unsignedLongValue)
//        
//        if let type = interruptionType{
//            if type == .Began{
//                
//                /* resume the audio if needed */
//                print("began4 interrupt")
//            } else{
//                print("end4 interrupt")
//            }
//        } else{
//            print("end5 interrupt")
//        }
//        
//    }
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        label.text = "Press Start to start tracking"
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.myViewController = self
//        
//        // Handle the text field's user input (closes keyboard when taps "return"
//        self.tagTextField.delegate = self
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: AVAudioRecorderDelegate
//    
//    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
//        print("audioRecorderDidFinishRecording - (1) phone call or (2) STOPPED")
//        print("iOS has stopped recording")
//        
//        if (flag){
//            // store in model
//            recordedAudio = RecordedAudio()
//            //            recordedAudio.filePathURL = recorder.url
//            recordedAudio.title = recorder.url.lastPathComponent
//            
//            // segue once we've finished processing the audio
//        } else{
//            print("recording not successful")
//        }
//    }
//    
//    func audioRecorderEndInterruption(recorder: AVAudioRecorder, withOptions flags: Int) {
//        print("* * * * * * * inside end interruption")
//        if flags == AVAudioSessionInterruptionFlags_ShouldResume{
//            print("inside end interruption2")
//        }
//    }
//}
//
//
//
//
//
//
////
////    @IBAction func startButton(sender: AnyObject) {
////        label.text = "updating"
////        let date = NSDate()
////        let stamp = Int(floor(date.timeIntervalSince1970*1000))
////
////        let timestamp_name = "\(stamp)"
////        fileurl = self.dir.URLByAppendingPathComponent(timestamp_name)
////
////        if timer_running == false {
////            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("sayHello"), userInfo: nil, repeats: true)
////            timer_running = true
////            soundSetup()
////        }
//
////    var stuckTimeInterval = 0.0
//
//
//
//
////    @IBAction func stopButton(sender: AnyObject) {
////        motionManager.stopAccelerometerUpdates()
//
////        Alamofire.request(.GET, postsEndpoint).responseJSON {
////            response in
////            if response.result.isSuccess{
////                NSLog("in GET REQUEST")
////                let jsonDic = response.result.value as! NSDictionary
////                let responseData = jsonDic["responseData"] as! NSDictionary
////            }
////        }
//
////        // stop audio recording
////        print("stopped recording")
////        print("recordedDecibelArray 2 \(recordedDecibelArray)")
////        print("recordedDateTimeArray 2 \(recordedDateTimeArray)")
////
////        audioRecorder.stop()
////
////        // wait for confirmation from server
////        // post recordDecibelArray to server
////
////        let audioSession = AVAudioSession.sharedInstance()
////
////        do {
////            try audioSession.setActive(false)
////        } catch _ {
////        }
////
////
////
////        label.text = "stopped updating"
////
////        // send data to server
////        // START OF READ FROM FILE ///
////        NSLog("START READ OF FILE")
////
////        if Reachability.isConnectedToNetwork() == true {
////
////            do {
////                let readFile = try String(contentsOfFile: PATH_STRING, encoding: NSUTF8StringEncoding)
////                let date = NSDate()
////                let stamp = Int(floor(date.timeIntervalSince1970*1000))
////                let timestmp = "\(stamp)" + ","
////                var data_file = self.userID + "," + timestmp
////                data_file = data_file + readFile
////                let upload_params = ["User": self.userID, "Date": timestmp, "\nData": readFile]
////                // POST REQUEST START
////                Alamofire.request(.POST, "http://sleep.cs.brown.edu:80" , parameters: upload_params).response { res in
////                    NSLog("IN POST REUQUEST STOP BUTTON")
////                    print(res)
////                }
////
////                // POST REQUEST END
////                NSLog("\(readFile)")
////            } catch let error as NSError {
////                print("Error: \(error)")
////            }
////        }
////        else {
////            NSLog("NO INTERNET")
////            // check periodically for internet and upload data then!
////           // NSTimer to check for wifi exponentially?
////        }
//
//
//
//
//
//
//
////    func audioRecorderBeginInterruption(recorder: AVAudioRecorder){
////        print("* * * * * * * inside begin interruption")
////        self.timer.invalidate()
////        self.audioRecorder.pause()
////        self.timer_running = false
////
////        // recording will stop
////        let audioSession = AVAudioSession.sharedInstance()
////        do{
////            //            try self.myViewController.audioSession.setActive(false)
////            try audioSession.setActive(false)
////        } catch let error as NSError {
////            print(error.description)
////        }
//
////    }
//
//
//
//
////    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
////        print("inside player begin interruption3")
////    }
////
////    func audioPlayerEndInterruption(player: AVAudioPlayer) {
////        print("inside player end interruption3")
////    }
//
//
