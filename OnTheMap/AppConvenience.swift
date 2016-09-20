//
//  AppConvenience.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/3/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

// MARK: GCDBlackBox
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

// MARK:
func displayError(_ hostViewController: UIViewController, error: NSError) {
    let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(AlertActions.Dismiss)
    
    print(error)
    
    if (error.code > 0) {
        performUIUpdatesOnMain {
            hostViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
