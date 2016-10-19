//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/13/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Properties
    let parseClient = ParseClient.sharedInstance()

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsUpdated), name: ParseClient.Notifications.Updated, object: nil)
    }

    func studentLocationsUpdated() {

        var annotations = [MKPointAnnotation]()

        for studentLocation in parseClient.studentLocations {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)

            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = "\(studentLocation.mediaURL)"

            annotations.append(annotation)
        }

        performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
}

// MARK: MapViewController: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red

            if let urlString = annotation.subtitle!, !urlString.isEmpty {
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let urlString = view.annotation?.subtitle! {

            // GUARD: valid url?
            guard let url = URL(string: urlString), canOpenURL(url) else {
                let errorString = substituteKeyIn(string: ErrorStrings.InvalidURL, key: ErrorStringsKey.URL, value: urlString)
                displayError(host: self, error: NSError(domain: "mapView", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: errorString]))

                return
            }

            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
