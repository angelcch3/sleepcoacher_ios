//
//  UserInfoViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/26/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//


// This is the view controller for the page that gets the information from the user upon set up. This page also sets the "walkthrough" boolean to true, so the user has officially accepted the informed consent form once they click "Next" on this screen. 
import UIKit
import Alamofire

class UserInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gender_field: UITextField!
    @IBOutlet weak var notification_field: UITextField!
    @IBOutlet weak var medication_field: UITextField!
    @IBOutlet weak var occupation_field: UITextField!
    @IBOutlet weak var age_field: UITextField!
    @IBOutlet weak var carrier_field: UITextField!
    @IBOutlet weak var phone_number_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    
    // get the userid from the device
    let userID = UIDevice.current.identifierForVendor!.uuidString
    var postsEndpoint: String = "http://162.243.187.68:443"
    
    var sent_response = ""
    var is_it_true = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notification_field.delegate = self
        self.gender_field.delegate = self
        self.medication_field.delegate = self
        self.occupation_field.delegate = self
        self.email_field.delegate = self
        self.phone_number_field.delegate = self
        self.age_field.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ notification_field: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func send_data(_ sender: Any) {
         UserDefaults.standard.set(true, forKey: "Walkthrough")
        //set all the variables based on the input from the text fields
        var age = age_field.text
        var phone_number = phone_number_field.text
        var carrier = carrier_field.text
        var gender = gender_field.text
        var medication = medication_field.text
        var notification = notification_field.text
        var occupation = occupation_field.text
        var email = email_field.text
        
        
        // had to break this string in pieces because it was complaining that in one line it was too much
        var string_to_send = "Email:" + email! + ", PhoneNumber:" + phone_number!
        string_to_send = string_to_send + ", PhoneCarrier:" + carrier! + ", Age:"+age!
        string_to_send = string_to_send + ", Occupation:"+occupation!+", Medication:" + medication!
        string_to_send = string_to_send + ", Notification:"+notification!+", Gender:" + gender!
        
        if string_to_send.range(of:gender!) != nil{
           
        let upload_params = ["User": self.userID, "\nData": string_to_send]


            // request to send the user info data to the server.
        Alamofire.request("http://162.243.187.68:443", method: .post, parameters: upload_params).response { res in

            self.sent_response = String(describing: res.response?.statusCode)
            self.is_it_true = ("Optional(200)"==self.sent_response)

            
      }
        }
        
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
