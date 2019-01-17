//
//  SleepFlowThreeViewController.swift
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

class SleepFlowThreeViewController: UIViewController, AVAudioRecorderDelegate {
    
    let dir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as URL!
    var fileurl:URL?
    var PATH_STRING = ""
    
    // Variables for recording motion and audio
    let motionManager: CMMotionManager = CMMotionManager()
    let accelData: CMAccelerometerData = CMAccelerometerData()
    var recordedAudio: RecordedAudio!
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var content = ""
    var power: Float = 0.0
    var prevPower: Float = 0.0
    var timer = Timer()
    var timer_running = false
    var isStart = false
    var isRecording = false
    var start_timestamp = ""
    
    var soundPath = ""
    var soundURL: URL!
    var soundOriginPath = ""
    var accelOriginPath = ""
    var sent_response = ""
    var fileHandle: FileHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isStart = true
        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBOutlet weak var wakeUpButton: UIButton!
    
    @IBAction func wakeUpButtonDown(_ sender: Any) {
        isStart = false
        stop()
        sleepData.filePath = PATH_STRING
        sleepData.startTimestamp = start_timestamp
        sleepData.accelOriginPath = accelOriginPath
        sleepData.soundOriginPath = soundOriginPath
        sleepData.soundPath = soundPath
        sleepData.fileurl = fileurl
    }
    
    // Handles audio session interruption
    @objc func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            print("AUDIO INTERRUPTED")
            // Interruption began, take appropriate actions
            audioRecorder.pause()
            timer_running = false
            timer.invalidate()
        }
        else if type == .ended {
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    print("AUDIO RESUMED")
                    audioRecorder.record()
                    timer_running = true
                    startTimer()
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("AUDIO SHOULD NOT RESUME")
                }
            }
        }
        print(notification.description)
    }
    
    // Set up notifications (including alarms) that interrupt audiosession
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: .AVAudioSessionInterruption,
                                       object: nil)
    }
    
    // Sets up sound data collection
    func soundSetup() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.string(from: currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
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
                try audioSession.setActive(true)
            } catch _ {
                print("error with audio session")
            }
            self!.setupNotifications()
            
            self!.audioRecorder = try? AVAudioRecorder(url: filePath!, settings: [:])
            self!.audioRecorder.delegate = self
            self!.audioRecorder.isMeteringEnabled = true
            self!.audioRecorder.prepareToRecord()
            self!.audioRecorder.record()
        })
    }
    
    func startTimer() {
        print(currUser.uuid)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SleepFlowThreeViewController.updateFile), userInfo: nil, repeats: true)
    }
    
    enum DecibelError : Error{
        case youAreNotDoingYourJob
    }
    
    // Every time the NStimer fires, run this
    func updateSound(_ dateString: Int64) {
        do {
            try calculateDecibel()
        } catch DecibelError.youAreNotDoingYourJob{
            stop()
            start()
        } catch{
            print("Error")
        }
        
        let date = Date()
        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
        let paramString = ["Timestamp": dateString, "decibelLevel": power] as [String : Any];//, "ID_number": self.userID];
        
        let pathString: String = fileurl!.path
        // convert to string for reading from file
        
        PATH_STRING = pathString
        var stringNoise = ""
        let powerString = String(format:"%.2f", power)
        stringNoise = "Timestamp: " + dateString + ","
        stringNoise = stringNoise + "decibelLevel:" + powerString
        stringNoise = stringNoise + ";"
        
        let dataToWrite = stringNoise.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        if FileManager.default.fileExists(atPath: fileurl!.path) {
            var err:NSError?
            do {
                fileHandle = try FileHandle(forWritingTo: fileurl!)
                fileHandle.seekToEndOfFile()
                fileHandle.write(dataToWrite)
                let datastring = NSString(data: dataToWrite, encoding: String.Encoding.utf8.rawValue ) as! String
                // fileHandle.closeFile()
                
            } catch let error as NSError {
                err = error
                print("Can't open fileHandle \(err)", terminator: "")
            }
        }
        else {
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
    
    var g1 = 0.0
    var g2 = 0.0
    var g3 = 0.0
    var alpha = 0.8
    
    func updateFile() {
        motionManager.accelerometerUpdateInterval = 1 // Updates once per second
        
        let date = Date()
        let stamp = Int64(floor(date.timeIntervalSince1970*1000))
        
        var acceleration_xyz = 0.0;
        var acceleration_x = 0.0;
        var acceleration_y = 0.0;
        var acceleration_z = 0.0;
        
        updateSound(stamp);
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
            [weak self] (data: CMAccelerometerData?, error: Error?) in self!.isRecording = true
            
            acceleration_x =  data!.acceleration.x
            acceleration_y =  data!.acceleration.y
            acceleration_z =  data!.acceleration.z
            
            self!.g1 = self!.alpha * self!.g1 + (1-self!.alpha) * acceleration_x
            self!.g2 = self!.alpha * self!.g2 + (1-self!.alpha) * acceleration_y
            self!.g3 = self!.alpha * self!.g3 + (1-self!.alpha) * acceleration_z
            
            // adds up the accelerations over all 3 axes
            acceleration_xyz = fabs(acceleration_x - self!.g1) + fabs(acceleration_y - self!.g2) + fabs(acceleration_z - self!.g3)
            
            let string1 = String(format: "%.2f\n", acceleration_xyz)
            
            if let dataFromString = string1.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
            }
            
            var acceleration_data = ""
            var timestmp = ""
            acceleration_data = string1
            timestmp = "\(stamp)" + ","
            let tempData = timestmp + acceleration_data + "\(currUser.uuid)"
            let pathString: String = self!.fileurl!.path // convert to string for reading from file
            self!.PATH_STRING = pathString
            print(acceleration_xyz)
            
            // Write to file
            acceleration_data = acceleration_data+";"
            let stringToWrite  = "Timestamp: " + timestmp + "accelerometer: " + acceleration_data
            let dataToWrite = stringToWrite.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            // self!.fileurl! should be just fileurl
            if FileManager.default.fileExists(atPath: self!.fileurl!.path) {
                var err:NSError?
                do {
                    // self!.fileurl! should be just fileurl
                    let fileHandle = try FileHandle(forWritingTo: self!.fileurl!)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(dataToWrite)
                    let datastring = NSString(data: dataToWrite, encoding: String.Encoding.utf8.rawValue ) as! String
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
    
    func start() {
        let date = Date()
        let start_date = "\(date)"
        // may be problematic in the future we are fixing the int overflow problem in a janky way
        let x = floor(date.timeIntervalSince1970*1000)
        
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
    }
    
    // Delete acceleration and audio files
    func delete_func() {
        do {
            let filelist2 = try FileManager.default.contentsOfDirectory(atPath: accelOriginPath)
            
            if FileManager.default.fileExists(atPath: self.fileurl!.path) {
                do {
                    try FileManager.default.removeItem(at: self.fileurl!)
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.title = recorder.url.lastPathComponent
        } else {
            print("recording not successful")
        }
    }
    
    func calculateDecibel() throws {
        audioRecorder.updateMeters()
        
        // average of the two channels
        power = audioRecorder.averagePower(forChannel: 0)
        
        
        if (power <= -160.0 && power >= 160.0) {
            print("decibel error is not in threshold")
            throw DecibelError.youAreNotDoingYourJob
        }
        
        if (prevPower == power) {
            print("* * * * * * * prevPower == power * * * * * * * ")
            throw DecibelError.youAreNotDoingYourJob
        }
        power = audioRecorder.averagePower(forChannel: 0)
        prevPower = power
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
        fileHandle.closeFile()
        
        timer.invalidate()
        timer_running = false
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
}
