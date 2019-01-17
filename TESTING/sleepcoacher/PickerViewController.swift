//
//  PickerViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/26/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//

// This was the initial user info page, but it broke after i added the picker for the notification mode, so i had to start from scratch and now the one i'm using for real is "UserInfoViewController
import UIKit
import Alamofire

class PickerViewController: UIViewController { //, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
//    @IBOutlet weak var email_field: UITextField!
//    
//    @IBOutlet weak var phone_field: UITextField!
//    
//    @IBOutlet weak var carrier_field: UITextField!
//    
//    @IBOutlet weak var age_field: UITextField!
//    
//    @IBOutlet weak var occupation_field: UITextField!
//    
//    @IBOutlet weak var gender_field: UITextField!
//    
//    @IBOutlet weak var medication_field: UITextField!
    
    @IBOutlet weak var notification_label: UILabel!
    
//    @IBOutlet weak var notification_picker: UIPickerView!
//
//    
//    let notification_options = ["Email", "Phone Notificaiton"]
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
//        return notification_options[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return notification_options.count
//    }
//    
//    func pickerView(_ pickerVie: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        notification_label.text = notification_options[row]
//    }
//    
    
    let userID = UIDevice.current.identifierForVendor!.uuidString
    var postsEndpoint: String = "http://162.243.187.68:443"
    


    var sent_response = ""
    var is_it_true = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    @IBAction func send_data(_ sender: Any) {
//        UserDefaults.standard.set(true, forKey: "Walkthrough")
//        print ("sent data!")
//        var email = email_field.text
//        var phone_number = phone_field.text
//        var phone_carrier = carrier_field.text
//        var age = age_field.text
//        var occupation = occupation_field.text
//        var medication = medication_field.text
//        var notification = notification_label.text
//        
//        var string_to_send = "Email:" + email! + ", PhoneNumber:" + phone_number!
//        string_to_send = string_to_send + ", PhoneCarrier:" + phone_carrier! + ", Age:"+age!
//        string_to_send = string_to_send + ", Occupation:"+occupation!+", Medication:" + medication!
//        string_to_send = string_to_send + ", Notification:"+notification!
//        
//        print("String to send!")
//        print(string_to_send)
//        
//        let upload_params = ["User": self.userID, "\nData": string_to_send]
//        print("Upload params")
//        print(upload_params)
////        
////        Alamofire.request("http://162.243.187.68:443", method: .post, parameters: upload_params).response { res in
////            NSLog("IN POST REUQUEST STOP BUTTON")
////            self.sent_response = String(describing: res.response?.statusCode)
////            self.is_it_true = ("Optional(200)"==self.sent_response)
////            print(self.is_it_true)
////            print(self.sent_response)
//////            if self.is_it_true == true {
//////                self.delete_func()
//////            }
////        }
//    }

    
}
