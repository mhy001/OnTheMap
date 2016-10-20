//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/11/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import Foundation

class ParseClient: RequestTasks {

    // MARK: Properties
    let commonHeaders = [
        HTTPHeaderFields.ApplicationID: Constants.ApplicationID,
        HTTPHeaderFields.APIKey: Constants.APIKey
    ]
    var userLocation: StudentLocation? = nil
    var studentLocations = [StudentLocation]()
    
    // MARK: RequestTasks protocol
    class func sharedInstance() -> ParseClient {

        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getURL(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Scheme
        components.host = Constants.Host
        components.path = Constants.APIPath + (withPathExtension ?? "")
        
        return components.url!
    }
    
    func convertData(_ data: Data, completionHandlerForConvertData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        baseConvertData(data, completionHandlerForConvertData: completionHandlerForConvertData)
    }
}
