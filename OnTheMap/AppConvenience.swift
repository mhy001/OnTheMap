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

// MARK: Error handler
func displayError(host hostViewController: UIViewController, error: NSError) {

    print(error)
    
    if (error.code > 0) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.Dismiss, style: .default, handler: nil))

        performUIUpdatesOnMain {
            hostViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: URL validator
func canOpenURL(_ url: URL) -> Bool {

    return UIApplication.shared.canOpenURL(url)
}

// MARK: String key substitution
func substituteKeyIn(string: String, key: String, value: String) -> String {
    
    if string.range(of: "{\(key)}") != nil {
        return string.replacingOccurrences(of: "{\(key)}", with: value)
    }

    return string

}
