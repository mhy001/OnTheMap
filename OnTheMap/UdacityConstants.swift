//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/3/16.
//  Copyright © 2016 Myang. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // URLS
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let Session = "/session"
        static let UserData = "users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct HTTPHeaderFields {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }
    
    struct HTTPHeaderValues {
        static let JSON = "application/json"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        //static let Facebook = "facebook_mobile"
        //static let AccessToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Status = "status"
        static let Error = "error"
        static let Account = "account"
        static let UserKey = "key"
        static let Session = "session"
    }
    
}
