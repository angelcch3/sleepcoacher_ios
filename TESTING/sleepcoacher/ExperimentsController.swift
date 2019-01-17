//
//  ExperimentsController.swift
//  sleepcoacher
//
//  Created by angel cheung on 10/25/18.
//  Copyright © 2018 brown.hci. All rights reserved.
//

import UIKit

class ExperimentsController: UITableViewController {
    
    var experiments = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadExperiments()
    }
    
    func loadExperiments() {
        experiments += ["30 minutes of exercise", "Aromatherapy", "Audiobook",  "Avoid caffeine", "Avoid electronics before bed", "Avoid heavy meals at night", "Avoid liquids before bed", "Avoid naps", "Avoid pets on bed", "Breathable sheets", "Chamomile tea", "Different pillow", "Dim lights before bed", "Earplugs", "Eyemask", "Hot bath before bed", "Keep your room cool", "Mindful walking", "Pillow under your knees", "Relax before bed", "Roomier PJs", "Snack before bed", "Socks while sleeping", "Thoughts journal", "Visualizing", "White noise or music"]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return experiments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "ExperimentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExperimentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let currExperiment = experiments[indexPath.row]
        cell.label.setTitle(currExperiment, for: .normal)
        return cell
    }
    
}
