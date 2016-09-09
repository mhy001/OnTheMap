//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/3/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject, RequestTasks {
    
    // MARK: Properties
    var userID: String? = nil
    
    // MARK: RequestTasks protocol
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func getURL(withPathExtension: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        return components.URL!
    }
    
    func convertData(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertData", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK:
    func authenticateWithViewController(username username: String, password: String, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        let url = getURL(Methods.Session)
        let headers = [
            HTTPHeaderFields.Accept: HTTPHeaderValues.JSON,
            HTTPHeaderFields.ContentType: HTTPHeaderValues.JSON
        ]
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        taskForPOSTMethod(url, httpHeaders: headers, parameters: nil, jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForAuth(success: false, error: error)
            } else {
                if let account = results[JSONResponseKeys.Account] as? [String: AnyObject], userID = account[JSONResponseKeys.UserKey] as? String {
                    self.userID = userID
                    completionHandlerForAuth(success: true, error: nil)
                } else {
                    completionHandlerForAuth(success: false, error: NSError(domain: "authenticateWithViewController", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get userID in \(results)"]))
                }
            }
        }
    }
    
    func logout() {
        let url = getURL(Methods.Session)
        var headers = [String: String]()
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
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