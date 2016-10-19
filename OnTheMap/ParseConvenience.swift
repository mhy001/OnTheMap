//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/12/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import Foundation

// MARK: ParseClient (Convenient Resource Methods)
extension ParseClient {

    func getStudentLocations(completionHandlerForStudentLocations: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        let url = getURL()
        let headers = commonHeaders
        let parameters: [String: AnyObject] = [
            ParameterKeys.Limit: 100 as AnyObject,
            ParameterKeys.Order: "-\(JSONKeys.Updated)" as AnyObject
        ]
        let getStudentLocationsError = NSError(domain: "getStudentLocations", code: ErrorCodes.Parse, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedStudentLocationsUpdate])
        
        taskForGETMethod(baseURL: url, httpHeaders: headers, parameters: parameters) { (result, error) in
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                print(error)
                
                completionHandlerForStudentLocations(false, getStudentLocationsError)
                return
            }
            
            if let result = result?[JSONKeys.Results] as? [[String: AnyObject]] {
                let studentLocations = StudentLocation.studentLocationsFromResults(result)
                self.studentLocations = studentLocations
                
                completionHandlerForStudentLocations(true, nil)
            } else {
                completionHandlerForStudentLocations(false, getStudentLocationsError)
            }
        }
    }

    func getUserLocation(userKey: String) {

        let url = getURL()
        let headers = commonHeaders
        let parameters: [String: AnyObject] = [
            ParameterKeys.Where: "{\"\(JSONKeys.UniqueKey)\":\"\(userKey)\"}" as AnyObject
        ]

        taskForGETMethod(baseURL: url, httpHeaders: headers, parameters: parameters) { (result, error) in

            // GUARD: Was there an error?
            guard (error == nil) else {
                print(error)

                return
            }

            if let result = result?[JSONKeys.Results] as? [[String: AnyObject]] {
                let userLocation = StudentLocation.studentLocationsFromResults(result)

                if !userLocation.isEmpty {
                    self.userLocation = userLocation[0]
                }
            }
        }
    }

    func postUserLocation(userKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostUserLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        let url = getURL()
        var headers = commonHeaders
        headers[HTTPHeaderFields.ContentType] = HTTPHeaderValues.JSON
        let jsonBody = "{\"\(JSONKeys.UniqueKey)\": \"\(userKey)\", \"\(JSONKeys.FirstName)\": \"\(firstName)\", \"\(JSONKeys.LastName)\": \"\(lastName)\",\"\(JSONKeys.MapString)\": \"\(mapString)\", \"\(JSONKeys.MediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.Latitude)\": \(latitude), \"\(JSONKeys.Longitude)\": \(longitude)}"

        taskForPOSTMethod(baseURL: url, httpHeaders: headers, parameters: nil, jsonBody: jsonBody) { (results, error) in

            guard (error == nil) else {
                print(error)

                completionHandlerForPostUserLocation(false, NSError(domain: "postUserLocation", code: ErrorCodes.Parse, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedUserPost]))

                return
            }

            if let result = results as? [String: AnyObject], let objectID = result[JSONKeys.ObjectID] {
                self.userLocation = StudentLocation([JSONKeys.ObjectID: objectID])
                completionHandlerForPostUserLocation(true, nil)
            } else {
                print(error)

                completionHandlerForPostUserLocation(false, NSError(domain: "postUserLocation", code: ErrorCodes.Parse, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedUserPost]))
            }
        }
    }

    func updateUserLocation(objectID: String, userKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForUpdateUserLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        let url = getURL(withPathExtension: substituteKeyIn(string: Methods.Update, key: URLKeys.ObjectID, value: objectID))
        var headers = commonHeaders
        headers[HTTPHeaderFields.ContentType] = HTTPHeaderValues.JSON
        let jsonBody = "{\"\(JSONKeys.UniqueKey)\": \"\(userKey)\", \"\(JSONKeys.FirstName)\": \"\(firstName)\", \"\(JSONKeys.LastName)\": \"\(lastName)\",\"\(JSONKeys.MapString)\": \"\(mapString)\", \"\(JSONKeys.MediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.Latitude)\": \(latitude), \"\(JSONKeys.Longitude)\": \(longitude)}"

        taskForPUTMethod(baseURL: url, httpHeaders: headers, parameters: nil, jsonBody: jsonBody) { (results, error) in

            guard (error == nil) else {
                print(error)

                completionHandlerForUpdateUserLocation(false, NSError(domain: "updateUserLocation", code: ErrorCodes.Parse, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedUserUpdate]))

                return
            }

            if let result = results as? [String: AnyObject], let _ = result[JSONKeys.Updated] {
                completionHandlerForUpdateUserLocation(true, nil)
            } else {
                print(error)

                completionHandlerForUpdateUserLocation(false, NSError(domain: "updateUserLocation", code: ErrorCodes.Parse, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedUserUpdate]))
            }
        }
    }
}
