//
//  MainUITabBarController.swift
//  sleepcoacher
//
//  Created by Angel Cheung on 12/11/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit

class MainUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sleepFlowOneViewController = SleepFlowOneViewController()
        sleepFlowOneViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let experimentsController = ExperimentsController()
        experimentsController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        let historyViewController = HistoryViewController()
        historyViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
        let resultsViewController = ResultsViewController()
        resultsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 3)
        let viewControllerList = [ sleepFlowOneViewController, experimentsController, historyViewController, resultsViewController ]
        viewControllers = viewControllerList
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
