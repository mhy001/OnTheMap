//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/3/16.
//  Copyright © 2016 Myang. All rights reserved.
//

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
    
    func getURL(_ withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Scheme
        components.host = Constants.Host
        components.path = (withPathExtension ?? "")
        
        return components.url!
    }
    
    func convertData(_ data: Data, completionHandlerForConvertData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let newData = (data as NSData).subdata(with: NSMakeRange(5, data.count - 5))
        baseConvertData(newData, completionHandlerForConvertData: completionHandlerForConvertData)
    }
}
