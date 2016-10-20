//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/14/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: Properties
    let udacityClient = UdacityClient.sharedInstance()
    let parseClient = ParseClient.sharedInstance()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create navigation bar items
        navigationItem.title = Strings.Title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.Logout, style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentLocations)),
            UIBarButtonItem(image: UIImage(named: "Pin"), style: .plain, target: self, action: #selector(postLocation))
        ]

        parseClient.getUserLocation(userKey: udacityClient.userID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getStudentLocations()
    }
}

// MARK: TabBarViewController (Actions)
extension TabBarViewController {
    
    func logout() {

        dismiss(animated: true, completion: nil)
        udacityClient.logout()
    }
    
    func getStudentLocations() {

        parseClient.getStudentLocations { (success, error) in
            if success {
                NotificationCenter.default.post(name: ParseClient.Notifications.Updated, object: nil)
            } else {
                if let error = error {
                    displayError(host: self, error: error)
                } else {
                    print(ErrorStrings.WHATHAPPENED)
                }
            }
        }
    }
    
    func postLocation() {

        if let objectID = parseClient.userLocation?.objectID {

            let alertController = UIAlertController(title: nil, message: Strings.OverwriteMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Strings.Overwrite, style: .default) { (UIAlertAction) -> Void in
                self.launchPosting(objectID)
            })
            alertController.addAction(UIAlertAction(title: Strings.Cancel, style: .default, handler: nil))

            present(alertController, animated: true, completion: nil)
        } else {
            launchPosting()
        }
    }

    func launchPosting(_ objectID: String? = nil) {

        let postingViewController = storyboard!.instantiateViewController(withIdentifier: "postingViewController") as! InformationPostingViewController

        if let objectID = objectID {
            postingViewController.objectID = objectID
        }

        present(postingViewController, animated: true, completion: nil)
    }
}
