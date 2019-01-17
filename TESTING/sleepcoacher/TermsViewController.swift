//
//  TermsViewController.swift
//  sleepcoacher
//
//  Created by Nediyana Daskalova on 1/25/17.
//  Copyright © 2017 brown.hci. All rights reserved.
//

//This is the page that shows the informed consent form, loaded from terms.html
import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsWebView: UIWebView!
    
    @IBAction func agreed(_ sender: Any) {
      print("Agreed")
        UserDefaults.standard.set("Chamomile tea", forKey: "currentExperiment")
        UserDefaults.standard.set("", forKey: "currentGoal")
        UserDefaults.standard.set(true, forKey: "Walkthrough")
   }
    
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadTermsHTML()
}

// Load HTML file from resources.
func loadTermsHTML() {
    print("in loaded")
    //Load the HTML file from resources
    // there is a terms.html in the sleepcoacher folder here that just has all the text as html so i can update that whenever i want to change the informed consent form.
    let url = Bundle.main.url(forResource: "terms", withExtension: "html")
    
    if let data = NSData(contentsOf: url!) {
        termsWebView.loadHTMLString(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as! String, baseURL: nil)
    }
}
}
