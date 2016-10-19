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
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsUpdated), name: ParseClient.Notifications.Updated, object: nil)
    }

    func studentLocationsUpdated() {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}

// MARK: TableViewController: UITableViewDelegate, UITableViewDataSource
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // Set cell defaults
        let studentLocation = parseClient.studentLocations[(indexPath as NSIndexPath).row]
        cell?.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell?.detailTextLabel!.text = "\(studentLocation.mediaURL)"
        cell?.imageView!.image = UIImage(named: "Pin")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return parseClient.studentLocations.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // GUARD: valid url?
        guard let url = URL(string: parseClient.studentLocations[indexPath.row].mediaURL), canOpenURL(url) else {
            let errorString = substituteKeyIn(string: ErrorStrings.InvalidURL, key: ErrorStringsKey.URL, value: parseClient.studentLocations[indexPath.row].mediaURL)
            displayError(host: self, error: NSError(domain: "tableView", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: errorString]))

            return
        }

        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

