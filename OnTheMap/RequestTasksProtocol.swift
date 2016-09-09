//
//  RequestTasks.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/5/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import Foundation

protocol RequestTasks {
    associatedtype requestClient
    static func sharedInstance() -> requestClient
    func getURL(withPathExtension: String?) -> NSURL
    func convertData(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void)
}

extension RequestTasks {
    
    // MARK: GET
    func taskForGETMethod(baseURL: NSURL, httpHeaders: [String: String]?, parameters: [String: AnyObject]?, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        return baseTaskMethod("GET", baseURL: baseURL, httpHeaders: httpHeaders, parameters: parameters, jsonBody: nil, completionHandlerForTask: completionHandlerForGET)
    }
    
    // MARK: POST
    func taskForPOSTMethod(baseURL: NSURL, httpHeaders: [String: String]?, parameters: [String: AnyObject]?, jsonBody: String?, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        return baseTaskMethod("POST", baseURL: baseURL, httpHeaders: httpHeaders, parameters: parameters, jsonBody: jsonBody, completionHandlerForTask: completionHandlerForPOST)
    }
    
    // MARK: DELETE
    func taskForDELETEMethod(baseURL: NSURL, httpHeaders: [String: String]?, parameters: [String: AnyObject]?, completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        return baseTaskMethod("DELETE", baseURL: baseURL, httpHeaders: httpHeaders, parameters: parameters, jsonBody: nil, completionHandlerForTask: completionHandlerForDELETE)
    }
    
    
    // MARK: Helpers
    private func baseTaskMethod(httpMethod: String, baseURL: NSURL, httpHeaders: [String: String]?, parameters: [String: AnyObject]?, jsonBody: String?, completionHandlerForTask: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the final URL, Configure the request
        let request = NSMutableURLRequest(URL: addURLParameters(baseURL, parameters: parameters))
        request.HTTPMethod = httpMethod
        
        if let httpHeaders = httpHeaders where !httpHeaders.isEmpty {
            for(key, value) in httpHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let jsonBody = jsonBody where jsonBody.characters.count > 0 {
            request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        // Make the request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            print(response)
            print("REQUEST TYPE: \(request.HTTPMethod)")
            if self.checkForRequestErrors("taskFor\(httpMethod)Method", data: data, response: response, error: error, completionHandlerForErrorCheck: completionHandlerForTask) {
                self.convertData(data!, completionHandlerForConvertData: completionHandlerForTask)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    private func addURLParameters(baseURL: NSURL, parameters: [String: AnyObject]?) -> NSURL {
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return baseURL
        }
        
        let components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func checkForRequestErrors(domain: String, data: NSData? , response: NSURLResponse?, error: NSError?, completionHandlerForErrorCheck: (result: AnyObject!, error: NSError?) -> Void) -> Bool {
        
        func sendError(error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForErrorCheck(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        // GUARD: Was there an error?
        guard (error == nil) else {
            sendError("There was an error with the request: \(error)")
            return false
        }
        
        // GUARD: Was the response a successful 2xx?
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            sendError("The request returned a status code other than 2xxx")
            return false
        }
        
        // GUARD: Was there any data returned?
        guard (data != nil) else {
            sendError("No data was returned by the request")
            return false
        }
        
        return true
    }
    
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
}