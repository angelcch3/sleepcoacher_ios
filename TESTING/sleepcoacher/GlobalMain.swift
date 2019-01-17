//
//  GlobalMain.swift
//  sleepcoacher
//
//  Created by angel cheung on 11/20/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

// This class manages:
// 1. A global instance of User for uuid and currentExperiment
// 2. A global instance of SleepData 
// 2. A global instance of Database for questions, given an experiment

import UIKit

// User class which stores uuid, currentExperiment, goal and getter/setter methods for local persistent store of currentExperiment and goal

class User {
    let uuid = UIDevice.current.identifierForVendor!.uuidString
    var startDate = "" 
    var currentExperiment = "Chamomile tea"
    var prevExperiment = ""
    var newExperiment = ""
    var goal = ""
    let defaults = UserDefaults.standard
    var timezone: String { return TimeZone.current.identifier }
    
    func setup() {
        defaults.set(currentExperiment, forKey: "currentExperiment")
    }
    
    func setDefaultExperiment() {
        defaults.set(currentExperiment, forKey: "currentExperiment")
    }
    
    func getDefaultExperiment() {
        let defaultCurrExperiment = defaults.object(forKey: "currentExperiment") as! String
        currentExperiment = defaultCurrExperiment
    }
    
    func setDefaultGoal() {
        defaults.set(goal, forKey: "currentGoal")
    }
    
    func getDefaultGoal() {
        let defaultGoal = defaults.object(forKey: "currentGoal") as! String
        goal = defaultGoal
    }
}
// Global instance of user
let currUser = User()

// Stores sleep data across views
class SleepData {
    var tags = ""
    var beforeRating = 0
    var afterRating = 0
    var startDate = ""
    var adherence = ""
    var disruptions = ""
    var disruptionDetails = ""
    var startTimestamp = ""
    var filePath = ""
    
    var accelOriginPath = ""
    var soundOriginPath = ""
    var fileurl:URL?
    var soundPath = ""
    
    func reset() {
        tags = ""
        beforeRating = 0
        afterRating = 0
        startDate = ""
        adherence = ""
        disruptions = ""
        startTimestamp = ""
        filePath = ""
    }
}

let sleepData = SleepData()

// Database class for accessing questions given current experiment.
// experiment["current experiment"][0] returns morning/evening.
// experiment["current experiment"][1] returns the question.
class Database {
    let experiment = [
        "30 minutes of excercise": ["evening","Did you do 30 minutes of excercise?"],
        "Avoid caffeine": ["evening","Did you avoid caffiene?"],
        "Avoid electronics before bed": ["evening","Did you avoid electronics before bedtime?"],
        "Avoid heavy meals at night": ["evening","Did you avoid heavy meals at night?"],
        "Avoid liquids before bed": ["evening","Did you avoid liquids before bed?"],
        "Avoid naps": ["evening","Did you avoid napping today?"],
        "Hot bath before bed": ["evening","Did you take a hot bath before bed?"],
        "Keep your room cool": ["evening","Did you keep your room cool before bed?"],
        "Snack before bed": ["evening","Did have a light snack before bed?"],
        "Chamomile tea": ["evening", "Did you drink chamomile tea?"],
        "Dim lights before bed":["evening", "Did you dim your lights before bed?"],
        "Mindful walking":["evening", "Did you have a mindful walk before bed?"],
        "Aromatherapy":["morning", "Did you do aromatherapy last night?"],
        "Breathable sheets":["morning", "Did you sleep with breathable sheets?"],
        "Pillow under your knees":["morning", "Did you sleep with a pillow under your knees?"],
        "Earplugs":["morning", "Did you sleep with earplugs in?"],
        "Different pillow":["morning", "Did you sleep with a different pillow?"],
        "Eyemask":["morning", "Did you sleep with an eyemask on?"],
        "Audiobook":["morning", "Did you listen to an audiobook while falling asleep?"],
        "Roomier PJs":["morning", "Did you sleep with roomier PJs?"],
        "Avoid pets on bed":["morning", "Did you avoid sleeping with pets on your bed?"],
        "Relax before bed":["morning", "Did you relax before bed?"],
        "White noise or music":["morning", "Did you listen to white noise or music while falling asleep?"],
        "Thoughts journal":["morning", "Did you write in a thoughts jorunal before bed?"],
        "Visualizing":["morning", "Did you visualize before bed?"],
        "Socks while sleeping":["morning", "Did you wear socks to bed?"],
    ]
}

// Global instance of database
let db = Database()
