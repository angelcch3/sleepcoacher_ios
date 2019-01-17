//
//  ResultsViewController.swift
//  sleepcoacher
//
//  Created by angel cheung on 10/25/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResultsViewController: UIViewController {
    let userID = UIDevice.current.identifierForVendor!.uuidString
    var postsEndpoint: String = "http://sleep.cs.brown.edu:443"
    var PATH_STRING = ""
    var fileurl:URL?
    
    var sent_response = ""
    var is_it_true = false
    
    var response = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResult()
        // Do any additional setup after loading the view.
    }
    
    struct Result: Codable {
        let stat: [Stat]
    }
    
    struct Stat: Codable {
        let date: String
        let update: String
    }
    
    func fetchResult(){
        let date = Date()
        let dateString = ("\(Int64(floor(date.timeIntervalSince1970*1000)))")
        let paramString = ["CurrentExperiment": "Aromatherapy", "GoogleAccount": self.userID] as [String : Any]; //, "ID_number": self.userID];
        let endpoint = "http://sleep.cs.brown.edu:443/" + self.userID + "/" + "Oct+21,+2018" + "/Result:"
        Alamofire.request(endpoint).responseJSON { response in
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
                    }
                    
                }
                self.results.text = resString
            }
        }
    }
    
    @IBOutlet weak var results: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
