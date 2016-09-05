//
//  RequestTasks.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/5/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import Foundation

class RequestTasks: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(baseURL: NSURL, httpHeaders: [String: String], parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the final URL, Configure the request
        var request = NSMutableURLRequest(URL: addURLParameters(baseURL, parameters: parameters))
        addHeaders(&request, httpHeaders: httpHeaders)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if !self.checkForRequestErrors("taskForGETMethod", data: data, response: response, error: error, completionHandlerForErrorCheck: completionHandlerForGET) {
                self.convertData(data!, completionHandlerForConvertData: completionHandlerForGET)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    func taskForPOSTMethod(baseURL: NSURL, httpHeaders: [String: String], parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the final URL, Configure the request
        var request = NSMutableURLRequest(URL: addURLParameters(baseURL, parameters: parameters))
        request.HTTPMethod = "POST"
        addHeaders(&request, httpHeaders: httpHeaders)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if !self.checkForRequestErrors("taskForPOSTMethod", data: data, response: response, error: error, completionHandlerForErrorCheck: completionHandlerForPOST) {
                self.convertData(data!, completionHandlerForConvertData: completionHandlerForPOST)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    private func addURLParameters(baseURL: NSURL, parameters: [String: AnyObject]) -> NSURL {
        let components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func addHeaders(inout request: NSMutableURLRequest, httpHeaders: [String: String]) {
        
        for(key, value) in httpHeaders {
            request.addValue(key, forHTTPHeaderField: value)
        }
    }
    
    private func checkForRequestErrors(domain: String, data: NSData? , response: NSURLResponse?, error: NSError?, completionHandlerForErrorCheck: (result: AnyObject!, error: NSError?) -> Void) -> Bool {
        
        func sendError(error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForErrorCheck(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        // GUARD: Was there an error?
        guard (error == nil) else {
            sendError("There was an error with the request: \(error)")
            return true
        }
        
        // GUARD: Was the response a successful 2xx?
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            sendError("The request returned a status code other than 2xxx")
            return true
        }
        
        // GUARD: Was there any data returned?
        guard (data != nil) else {
            sendError("No data was returned by the request")
            return true
        }
        
        return false
    }
    
    private func convertData(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertData", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
}