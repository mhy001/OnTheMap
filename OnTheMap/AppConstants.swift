//
//  AppConstants.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/14/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

// MARK: Errors
struct ErrorCodes {
    // Use 0 for non-displayed errors
    static let User = 1
    static let Udacity = 2
    static let Parse = 3
}

// MARK: Error Strings
struct ErrorStrings {
    static let EmptyCredentials = "Email or password field empty."
    static let FailedLogin = "Login failed."
    static let FailedStudentLocationsUpdate = "Could not update student locations."
    static let FailedGeocode = "Could not geocode {\(ErrorStringsKey.Location)}"
    static let FailedUserPost = "Failed to post location"
    static let FailedUserUpdate = "Failed to update location"
    static let InvalidURL = "{\(ErrorStringsKey.URL)} is not a valid URL."
    static let InvalidLocation = "{\(ErrorStringsKey.Location)} not found."

    static let WHATHAPPENED = "WHAT DID YOU DO?!"
}

struct ErrorStringsKey {
    static let URL = "URL"
    static let Location = "location"
}

// MARK: Strings
struct Strings {
    static let Title = "On The Map"
    static let Logout = "Logout"
    static let Dismiss = "Dismiss"
    static let Overwrite = "Overwrite"
    static let Cancel = "Cancel"
    static let FindOnMap = "Find on the map"
    static let Submit = "Submit"
    static let OverwriteMessage = "You have already posted a student location. Would you like to overwrite your current location?"
    static let PostingMessageAction = "studying"
    static let PostingMessage = "Where are you\n\(Strings.PostingMessageAction)\ntoday?"
    static let EnterLocation = "Enter your location here"
    static let EnterLink = "Enter a link to share"
    static let SubmitSuccess = "Location posted!"
}
