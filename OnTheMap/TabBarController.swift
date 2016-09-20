//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/14/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: Properties
    let udacityClient = UdacityClient.sharedInstance()
    let parseClient = ParseClient.sharedInstance()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create navigation bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentLocations)),
            UIBarButtonItem(image: UIImage(named: "Pin"), style: .plain, target: self, action: #selector(locate))
        ]
    }
}

// MARK: TableViewController (Actions)
extension TabBarController {
    
    func logout() {
        dismiss(animated: true, completion: nil)
        udacityClient.logout()
    }
    
    func getStudentLocations() {
        parseClient.getStudentLocations { (studentLocations, error) in
//            guard (error == nil) else {
//                displayError(self, error: error)
//                return
//            }
//            
//            if let studentLocations = studentLocations {
//                self.studentLocations = studentLocations
//                performUIUpdatesOnMain {
//                    self.tableView.reloadData()
//                    self.tableView.setContentOffset(CGPoint.zero, animated: true)
//                }
//            }
        }
    }
    
    func locate() {
        
    }
}
