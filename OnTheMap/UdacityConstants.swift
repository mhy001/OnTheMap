//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/3/16.
//  Copyright © 2016 Myang. All rights reserved.
//

// MARK: UdcaityClient (Constants)
extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        // URLS
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let APIPath = "/api"
        static let SignUp = "/account/auth#!/signup"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "\(Constants.APIPath)/session"
        static let UserData = "\(Constants.APIPath)/users/{\(URLKeys.UserID)}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: HTTP Header Fields
    struct HTTPHeaderFields {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }
    
    // MARK: HTTP Header Values
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
        static let Registered = "registered"
        static let Session = "session"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
}
