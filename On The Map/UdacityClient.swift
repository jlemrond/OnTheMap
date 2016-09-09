//
//  UdacityClient.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/3/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation

class UdacityClient: NSObject, Networkable {

    // Singleton set up.
    static let sharedInstance = UdacityClient()
    private override init() {
        super.init()
    }

    // Shared Session.
    let session = NSURLSession.sharedSession()

    // Authentication/User Variables.
    var sessionID: String?
    var accountKey: String?
    var firstName: String?
    var lastName: String?


    /// Get Session ID when a valid username and password is submitted.
    func getSessionID(username username: String, password: String, completionHandler: (error: String?) -> Void) {
        print("Function Called: Get Session ID")

        let url = createUdacityURL(.login)

        // Request Details
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        makeAPIRequest(request) { (result, error) in

            guard let jsonData = result else {

                if (error?.code == 403) {
                    completionHandler(error: "Invalid username and password.")
                    return
                }

                completionHandler(error: error?.localizedDescription)
                return

            }

            // Get Session Data
            guard let sessionData = jsonData[ResponseKeys.session] as? [String: AnyObject] else {
                completionHandler(error: "Session data unavailable.")
                return
            }

            // Get Session ID form data
            guard let sessionID = sessionData[ResponseKeys.id] as? String else {
                completionHandler(error: "No session ID returned.")
                return
            }

            // Get Account Data
            guard let accountData = jsonData[ResponseKeys.account] as? [String: AnyObject] else {
                completionHandler(error: "Account data unavailable.")
                return
            }

            // Get Account Key
            guard let accountKey = accountData[ResponseKeys.key] as? String else {
                completionHandler(error: "Unable to get Account ID")
                return
            }

            // Store Key/ID in UdacityClient
            self.sessionID = sessionID
            self.accountKey = accountKey
            
            completionHandler(error: nil)
        }

    }

    /// Get User Data from Udacity.
    func getUserData(completionHandler: ((error: String?) -> Void)) {
        print("Function Called: Get User Data")

        let url = createUdacityURL(.getUserData)

        let request = NSMutableURLRequest(URL: url)
        
        makeAPIRequest(request) { (result, error) in

            guard let jsonData = result else {
                completionHandler(error: error?.localizedDescription)
                return
            }

            guard let userData = jsonData[ResponseKeys.user] as? [String: AnyObject] else {
                completionHandler(error: "No user data returned")
                return
            }

            if let firstName = userData[ResponseKeys.firstName] {
                self.firstName = String(firstName)
            }

            if let lastName = userData[ResponseKeys.lastName] {
                self.lastName = String(lastName)
            }

            print("User Data Aquired")
            completionHandler(error: nil)

        }

    }
    //  MARK: Logout
    /// Delete sessionID from Udacity in order to logout.
    func logout(completion: (response: AnyObject?, error: String?) -> Void) {

        let url = createUdacityURL(.login)

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"

        var xsrfcookie: NSHTTPCookie?
        let sharedCookie = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        guard let cookies = sharedCookie.cookies else {
            print("Unable to get cookie data")
            return
        }

        for cookie in cookies {
            if cookie.name == "XSRF-TOKEN" {
                xsrfcookie = cookie
            }
        }

        guard let xsrfCookie = xsrfcookie else {
            print("No XSRF-TOKEN available in cookies")
            return
        }

        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")

        makeAPIRequest(request) { (result, error) in
            guard error == nil else {
                print(error)
                return
            }

            completion(response: result, error: nil)
        }



    }

    /// Parse returned data into readable JSON.
    func parseJSONData(data: NSData) -> AnyObject? {

        // Delete the first 5 characters in the data. (Udacity Specific Thing)
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

        // Parse data into JSON
        var jsonData: AnyObject!
        do {
            jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            print("Unable to deserialize JSON data")
            return nil
        }

        print("JSON Data parsed: \n\(jsonData)")

        return jsonData
    }

    /// Create URL for Udacity's API based on method provided.
    private func createUdacityURL(method: UdacityClient.method) -> NSURL {

        var methodPath: String

        switch method {
        case .login:
            methodPath = method.rawValue
        case .getUserData:
            guard let accountKey = accountKey else {
                methodPath = method.rawValue
                break
            }

            methodPath = method.rawValue + accountKey
        }

        // Components to construct the URL
        let components = NSURLComponents()
        components.scheme = URL.apiScheme
        components.host = URL.apiHost
        components.path = URL.apiPath + methodPath

        print("URL for request: \(String(components.URL!))")

        return components.URL!
    }

}

// MARK: - Udacity Client Constants
extension UdacityClient {

    //MARK: Sign Up URL
    struct SignUp {
        static let url: NSURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup")!
    }

    // MARK: URL Components
    struct URL {

        static let apiScheme: String = "https"
        static let apiHost: String = "www.udacity.com"
        static let apiPath: String = "/api"

    }

    enum method: String {

        case login = "/session"
        case getUserData = "/users/"

    }

    // MARK: Response Keys
    struct ResponseKeys {

        static let session = "session"
        static let id = "id"
        static let expiration = "expiration"

        static let account = "account"
        static let key = "key"
        static let registered = "registered"

        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"

    }

}
