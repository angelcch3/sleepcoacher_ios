//
//  SleepSummaryViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/26/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//

import UIKit

class SleepSummaryViewController: UIViewController {
    
    var bedtime_stamp = String()
    var waketime_stamp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_button(_ sender: Any) {
        hours_slept_label.text=""
        bedtime_label.text=""
        waketime_label.text=""
    }
    
    @IBAction func show_summary(_ sender: Any) {
        hours_slept_label.text = "8"
                
        bedtime_label.text = bedtime_stamp
        
        waketime_label.text = waketime_stamp    }
    
    @IBOutlet weak var hours_slept_label: UILabel!
    
    @IBOutlet weak var bedtime_label: UILabel!

    @IBOutlet weak var waketime_label: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
