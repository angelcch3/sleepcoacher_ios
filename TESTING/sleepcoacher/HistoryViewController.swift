//
//  HistoryViewController.swift
//  sleepcoacher
//
//  Created by angel cheung on 10/25/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController {
    let userID = UIDevice.current.identifierForVendor!.uuidString
    var postsEndpoint: String = "http://sleep.cs.brown.edu:443"
    var PATH_STRING = ""
    var fileurl:URL?

    var sent_response = ""
    var is_it_true = false
    
    var response = ""
    
    var sleepStats = [[String]]()
    
    // put array of arrays for each sleepstat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHistory()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var HistoryLabel: UILabel!
    
    struct Result: Codable {
        let stat: [Stat]
    }
    
    struct Stat: Codable {
        let date: String
        let update: String
    }
    
    func fetchHistory(){
        let date = Date()
        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
        let paramString = ["CurrentExperiment": "Aromatherapy", "GoogleAccount": self.userID] as [String : Any]; //, "ID_number": self.userID];
        let endpoint = "http://sleep.cs.brown.edu:443/" + self.userID + "/" + "Oct+21,+2018" + "/Daily:"
        let devEndpoint = "http://sleep.cs.brown.edu:443/B08C823C-25FB-4F9C-8FD4-DEA3DE48E44E/Oct+21,+2018/Daily:"
        Alamofire.request(devEndpoint).responseJSON { response in
            if let resdata = response.data, let resString = String(data: resdata, encoding: .utf8) {
                if let range = resString.range(of : "{") {
                    var jsonString = String(resString[range.upperBound...])
                    jsonString = "{" + jsonString
                    let jsonData = jsonString.data(using: .utf8)!
                    guard let resStruct = try? JSONDecoder().decode(Result.self, from: jsonData) else {
                        print("fuck")
                        return
                    }
                    for statStruct in resStruct.stat {
                        print(statStruct.update)
                        print(statStruct.date)
                        let sleepDataStr = String(statStruct.update)
                        if let range = sleepDataStr!.range(of: "SleepCoacher:") {
                            let sleepDataStr1 = String(sleepDataStr![range.upperBound...])
                            print(sleepDataStr1)
                            let sleepDataArr = sleepDataStr1.components(separatedBy: ";")
                            print(sleepDataArr)
                            self.sleepStats += [sleepDataArr]
                        }
                    }
                    print(self.sleepStats)
                    
                }
                self.HistoryLabel.text = resString
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
