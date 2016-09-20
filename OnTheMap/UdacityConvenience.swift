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
        let url = getURL(Methods.Session)
        let headers = [
            HTTPHeaderFields.Accept: HTTPHeaderValues.JSON,
            HTTPHeaderFields.ContentType: HTTPHeaderValues.JSON
        ]
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        let loginError = NSError(domain: "authenticate", code: ErrorCodes.Udacity, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.FailedLogin])
        
        taskForPOSTMethod(url, httpHeaders: headers, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                print(error)
                
                completionHandlerForAuth(false, loginError)
                return
            }
            
            // GUARD: Was authentication successful?
            guard let account = results?[JSONResponseKeys.Account] as? [String: AnyObject] else {
                if let responseError = results?[JSONResponseKeys.Error] as? String {
                    print(responseError)
                }
                
                completionHandlerForAuth(false, loginError)
                return
            }
            
            // Get the userID
            if let userID = account[JSONResponseKeys.UserKey] as? String, let registered = account[JSONResponseKeys.Registered] as? Bool , registered == true {
                self.userID = userID
                completionHandlerForAuth(true, nil)
            } else {
                completionHandlerForAuth(false, loginError)
            }
        }
    }
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: (_ success: Bool, _ error: NSError?) -> Void) {
        //let url = getURL(Constants.SignUpPath)
        
    }
    
    func logout() {
        let url = getURL(Methods.Session)
        var headers = [String: String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            headers[HTTPHeaderFields.XSRFToken] = xsrfCookie.value
        }
        
        taskForDELETEMethod(url, httpHeaders: headers, parameters: nil) { (results, error) in
            if let error = error {
                print(error)
            } else {
                print("LOGGED OUT")
            }
        }
    }
}
