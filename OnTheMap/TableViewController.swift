//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/13/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: Properties
    let parseClient = ParseClient.sharedInstance()
    var studentLocations = [StudentLocation]()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studentLocations = parseClient.studentLocations
    }
}

// MARK: TableViewController: UITableViewDelegate, UITableViewDataSource
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // Set cell defaults
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        cell?.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell?.imageView!.image = UIImage(named: "Pin")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return studentLocations.count
    }
}

