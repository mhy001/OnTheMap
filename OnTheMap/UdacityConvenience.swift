//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/11/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

// MARK: UdacityClient (Convenient Resource Methods)
extension UdacityClient {
    
    func authenticate(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        let url = getURL(withPathExtension: Methods.Session)
        let headers = [
            HTTPHeaderFields.Accept: HTTPHeaderValues.JSON,
            HTTPHeaderFields.ContentType: HTTPHeaderValues.JSON
        ]
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        taskForPOSTMethod(baseURL: url, httpHeaders: headers, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                print(error)
                
                completionHandlerForAuth(false, NSError(domain: "authenticate", code: ErrorCodes.Udacity, userInfo: [NSLocalizedDescriptionKey: error!.localizedDescription]))
                return
            }
            
            // Connection succeeded but authentication failed
            if let responseError = results?[JSONResponseKeys.Error] as? String {
                completionHandlerForAuth(false, NSError(domain: "authenticate", code: ErrorCodes.Udacity, userInfo: [NSLocalizedDescriptionKey: responseError]))
                return
            }
            
            // Success
            if let account = results?[JSONResponseKeys.Account] as? [String: AnyObject] {

                // Get the userID
                if let userID = account[JSONResponseKeys.UserKey] as? String, let registered = account[JSONResponseKeys.Registered] as? Bool , registered == true {
                    self.userID = userID
                    completionHandlerForAuth(true, nil)
                    self.getUserData(userID: userID)
                    return
                }
            }
            
            // Catch-all failure
            completionHandlerForAuth(false, NSError(domain: "authenticate", code: ErrorCodes.Udacity, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedLogin]))
        }
    }

    func getUserData(userID: String) {

        let url = getURL(withPathExtension: substituteKeyIn(string: Methods.UserData, key: URLKeys.UserID, value: userID))

        taskForGETMethod(baseURL: url, httpHeaders: nil, parameters: nil) { (results, error) in

            //GUARD: Was there an error?
            guard (error == nil) else {
                print(error)
                return
            }

            guard let user = results?[JSONResponseKeys.User] as? [String: AnyObject] else {
                print("No Udacity user found")

                return
            }

            // Get user first and last name
            if let firstName = user[JSONResponseKeys.FirstName] as? String, let lastName = user[JSONResponseKeys.LastName] as? String {
                self.firstName = firstName
                self.lastName = lastName
            } else {
                print("Udacity user has no name")
            }
        }
    }
    
    func logout() {
        let url = getURL(withPathExtension: Methods.Session)
        var headers = [String: String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            headers[HTTPHeaderFields.XSRFToken] = xsrfCookie.value
        }
        
        taskForDELETEMethod(baseURL: url, httpHeaders: headers, parameters: nil) { (results, error) in
            if let error = error {
                print(error)
            } else {
                print("LOGGED OUT")
            }
        }
    }
}
