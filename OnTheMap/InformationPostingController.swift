//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 10/9/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    // MARK: Properties
    let parseClient = ParseClient.sharedInstance()
    let udacityClient = UdacityClient.sharedInstance()
    var objectID: String? = nil
    var colorTheme: UIColor? = nil
    var placemark: CLPlacemark? = nil


    // MARK: Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setView(start: true)
    }

    // MARK: Actions
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func findOnMap(_ sender: AnyObject) {

        startActivity()

        CLGeocoder().geocodeAddressString(locationField.text!) { (placemarks, error) in

            self.stopActivity()

            // GUARD: Was there an error?
            guard (error == nil) else {
                print(error)

                let errorString = substituteKeyIn(string: ErrorStrings.FailedGeocode, key: ErrorStringsKey.Location, value: self.locationField.text!)
                displayError(host: self, error: NSError(domain: "findOnMap", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: errorString]))

                return
            }

            if let placemarks = placemarks, placemarks.count > 0 {
                self.placemark = placemarks[0]
                self.mapView.showAnnotations([MKPlacemark(placemark: placemarks[0])], animated: true)
                self.setView(start: false)
            } else {
                let errorString = substituteKeyIn(string: ErrorStrings.InvalidLocation, key: ErrorStringsKey.Location, value: self.locationField.text!)
                displayError(host: self, error: NSError(domain: "findOnMap", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: errorString]))
            }
        }
    }


    @IBAction func submit(_ sender: AnyObject) {

        // GUARD: Check for posted location
        guard let postedLocation = placemark?.location else {
            setView(start: true)

            displayError(host: self, error: NSError(domain: "submit", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.WHATHAPPENED]))

            return
        }

        startActivity()

        func completionHandler(success: Bool, error: NSError?) {

            stopActivity()

            if success {
                dismiss(animated: true, completion: nil)
            } else {
                if let error = error {
                    displayError(host: self, error: error)
                } else {
                    displayError(host: self, error: NSError(domain: "informationSubmit", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.WHATHAPPENED]))
                }
            }
        }

        if let objectID = objectID {
            parseClient.updateUserLocation(objectID: objectID, userKey: udacityClient.userID, firstName: udacityClient.firstName, lastName: udacityClient.lastName, mapString: locationField.text!, mediaURL: linkField.text!, latitude: postedLocation.coordinate.latitude, longitude: postedLocation.coordinate.longitude) { (success, error) in

                completionHandler(success: success, error: error)
            }

        } else {
            parseClient.postUserLocation(userKey: udacityClient.userID, firstName: udacityClient.firstName, lastName: udacityClient.lastName, mapString: locationField.text!, mediaURL: linkField.text!, latitude: postedLocation.coordinate.latitude, longitude: postedLocation.coordinate.longitude) { (success, error) in

                completionHandler(success: success, error: error)
            }
        }
    }

}

// MARK: Configure UI
extension InformationPostingViewController {

    fileprivate func setUpUI() {

        colorTheme = cancelButton.currentTitleColor
        cancelButton.setTitle(Strings.Cancel, for: .normal)
        cancelButton.sizeToFit()

        let range = (Strings.PostingMessage as NSString).range(of: Strings.PostingMessageAction)
        let attributedString = NSMutableAttributedString(string: Strings.PostingMessage)
        attributedString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 25)], range: range)
        label.attributedText = attributedString

        linkField.attributedPlaceholder = NSAttributedString(string: Strings.EnterLink, attributes: [NSForegroundColorAttributeName: UIColor.white])

        locationField.attributedPlaceholder = NSAttributedString(string: Strings.EnterLocation, attributes: [NSForegroundColorAttributeName: UIColor.white])

        findOnMapButton.setTitle(Strings.FindOnMap, for: .normal)
        findOnMapButton.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15)
        findOnMapButton.sizeToFit()

        submitButton.setTitle(Strings.Submit, for: .normal)
        submitButton.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15)
        submitButton.sizeToFit()
    }

    fileprivate func setView(start: Bool) {

        labelView.isHidden = !start
        locationView.isHidden = !start
        findOnMapButton.isHidden = !start

        linkView.isHidden = start
        mapView.isHidden = start
        submitButton.isHidden = start

        if start {
            cancelButton.setTitleColor(colorTheme!, for: .normal)
        } else {
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    fileprivate func startActivity() {

        activityIndicator.startAnimating()
        setUIEnabled(enabled: false)
    }

    fileprivate func stopActivity() {

        activityIndicator.stopAnimating()
        setUIEnabled(enabled: true)
    }

    fileprivate func setUIEnabled(enabled: Bool) {

        cancelButton.isEnabled = enabled
        linkField.isEnabled = enabled
        locationField.isEnabled = enabled
        findOnMapButton.isEnabled = enabled
        submitButton.isEnabled = enabled
        mapView.isUserInteractionEnabled = enabled

        activityIndicator.isHidden = enabled

        cancelButton.alpha = enabled ? 1.0 : 0.5
        linkField.alpha = enabled ? 1.0 : 0.5
        locationField.alpha = enabled ? 1.0 : 0.5
        findOnMapButton.alpha = enabled ? 1.0 : 0.5
        submitButton.alpha = enabled ? 1.0 : 0.5
        mapView.alpha = enabled ? 1.0 : 0.5
    }
}
