 //
//  AppDelegate.swift
//  oct21
//
//  Created by Nediyana Daskalova on 10/21/15.
//  Copyright © 2015 nediyana. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
/*
    func endInterrupt(){
        print("end interrupt")
    }
    
    func sessionInterrupted(_ notification: Notification){
        print("session interrupted")


//        if let info: NSDictionary = notification.userInfo {
//            if let type: UInt = info.objectForKey(AVAudioSessionInterruptionTypeKey) as? UInt {
//                if type == AVAudioSessionInterruptionType.Began.rawValue {
//                    beginInterrupt()
//                } else if type == AVAudioSessionInterruptionType.Ended.rawValue {
//                    if let _: UInt = info.objectForKey(AVAudioSessionInterruptionOptionKey) as? UInt {
//                        if type == AVAudioSessionInterruptionOptions.ShouldResume.rawValue {
//                            endInterrupt()
//                        }
//                    }
//                } else {
//                    print("end2 interrupt")
//                }
//            }
//        }
        
        
//        let interruptionTypeAsObject =
//        notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
//        
//        let interruptionType = AVAudioSessionInterruptionType(rawValue:
//            interruptionTypeAsObject.unsignedLongValue)
//        
//        if let type = interruptionType{
//            if type == .Ended{
//                print("end3 interrupt")
//                /* resume the audio if needed */
//                
//            }
//        }
        
        
//        if let info = notification.userInfo{
//            let type = info[AVAudioSessionInterruptionTypeKey] as!AVAudioSessionInterruptionType
//            
//            if type == .Began {
//                beginInterrupt()
//            }else {
//                let options = info[AVAudioSessionInterruptionOptionKey] as! AVAudioSessionInterruptionOptions
//                if options == .ShouldResume {
//                    endInterrupt()
//                }
//            }
//        }
        
        
//        if let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber{
//            if let type = AVAudioSessionInterruptionType(rawValue: typeValue.unsignedLongValue){
//                if type == .Began{
//                    print("interruption: began")
//                } else{
//                    print("interruption: ended")
//                }
//
////                switch type {
////                    case .Began:
////                        print("began")
////                    case .Ended:
////                        print("ended")
////                }
//            }
//        }
        
//        
//        if let info = notification.userInfo{
//            let type = info[AVAudioSessionInterruptionTypeKey] as! AVAudioSessionInterruptionType
//            
//            if type == .Began{
//                // stop recording
//                print("- - - -BEGIN INTERRUPTION")
//            } else{
//                print("- - - -END INTERRUPTION")
//                // resume recording
//            }
//        }
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("IN APP DELEGATE")
        if !UserDefaults.standard.bool(forKey: "Walkthrough") {
            UserDefaults.standard.set(false, forKey: "Walkthrough")
        }
        print("AFTER WALKTHROUGH APP DELEGATE")
        
        // not sure if I need this.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myViewController = vc
        
//        let audioSession = AVAudioSession.sharedInstance()
        
        let center = NotificationCenter.default
        
        center.addObserver(self,
            selector:#selector(AppDelegate.sessionInterrupted(_:)),
            name:NSNotification.Name.AVAudioSessionInterruption,
            object:AVAudioSession.sharedInstance()) //self.myViewController.audioSession)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // my duties!
            // pause ongoing tasks
            // disable timers
        
        print("applicationWillResignActive")
//        self.myViewController.audioRecorder.pause()
//        self.myViewController.timer.invalidate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // my duties!
            // release shared resources
            // save user data
            // invalidate timers
            // save app state so you can restore if app is terminated
            // disable UI updates
        
        print("applicationDidEnterBackground")
        
        
        /// TO DO: MOVE TO BEGINNING OF INTERURPTION
//        self.myViewController.timer.invalidate()
//        self.myViewController.audioRecorder.pause()
//        self.myViewController.timer_running = false
//        
//        // recording will stop
//        let audioSession = AVAudioSession.sharedInstance()
//        do{
//            try audioSession.setActive(false)
//        } catch let error as NSError {
//            print(error.description)
//        }
        
    }
    
    func sayHello(){
        self.myViewController.sayHello()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        print("applicationWillEnterForeground")
//        self.myViewController.timer_running = false
//        self.myViewController.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self.myViewController, selector: Selector("self.myViewController.sayHello:"), userInfo: nil, repeats: true)
//

        
        // TO DO: MOVE TO WHEN INTERRUPTION IS DONE
        
        // reset timer to false b/c audio recording is synced
        self.myViewController.timer.invalidate()
        self.myViewController.timer_running = false
        
        // recording will start
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setActive(true)
        } catch let error as NSError {
            print(error.description)
        }
        
        // everything in start button
        self.myViewController.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self.myViewController, selector: Selector("sayHello"), userInfo: nil, repeats: true)
        self.myViewController.timer_running = true
        self.myViewController.soundSetup()
        */
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("applicationDidBecomeActive")
        
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }


    


