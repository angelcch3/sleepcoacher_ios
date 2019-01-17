//
//  PopUpViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/25/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//

//This is currently just a pop up that we promised in the IRB. 
import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func agree(_ sender: Any) {
        print("Agreed")
        // This used to be the place where I set the key, but then I changed it so that it's only set once they enter their information and click Next on the UserInfoViewController.
        //        UserDefaults.standard.set(true, forKey: "Walkthrough")
        print("set the key")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
