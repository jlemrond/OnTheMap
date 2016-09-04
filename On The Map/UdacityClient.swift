//
//  UdacityClient.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/3/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {

    // Singleton set up.
    static let sharedInstance = UdacityClient()
    private override init() {
        super.init()
    }

    // Shared Session.
    let session = NSURLSession.sharedSession()

    // Authentication/User Variables.
    var sessionID: String?
    var accountKey: Int?


    /// Get Session ID when a valid username and password is submitted.
    func getSessionID(username username: String, password: String, completionHandler: (error: String?) -> Void) -> NSURLSessionDataTask {

        let url = createUdacityURL()

        // Request Details
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        // Set up task and completion handler
        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            // Error Function
            func sendError(message: String) {
                print(message)
                print("Error: \(error)")
                print("Response: \(response)")
                completionHandler(error: message)
            }

            // Next 3 guard statements validate we have received the data we 
            // want to recieve, and not an error
            guard error == nil else {
                if error?.code == -1001 {
                    sendError("Request Timed Out. Check your network connection.")
                    return
                }
                
                sendError("An error was found with your request.")
                return
            }

            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Unable to Login, please check your username and password.")
                return
            }

            guard let data = data else {
                sendError("No data was returned")
                return
            }

            // Delete the first 5 characters in the data. (Udacity Specific Thing)
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

            // Parse data into JSON
            var jsonData: AnyObject!
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Unable to deserialize JSON data")
                return
            }

            // Get Session Data
            guard let sessionData = jsonData[ResponseKeys.session] as? [String: AnyObject] else {
                sendError("No session data")
                return
            }

            // Get Session ID form data
            guard let sessionID = sessionData[ResponseKeys.id] as? String else {
                sendError("No session ID returned")
                return
            }

            print(sessionID)
            print(jsonData)

            self.sessionID = sessionID

            completionHandler(error: nil)

        }

        // Execute request
        task.resume()

        return task

    }

    private func createUdacityURL() -> NSURL {

        // Components to construct the URL
        let components = NSURLComponents()
        components.scheme = URL.apiScheme
        components.host = URL.apiHost
        components.path = URL.apiPath

        // TODO: Add parameters loop.

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
        static let apiPath: String = "/api/session"

    }

    // MARK: Response Keys
    struct ResponseKeys {

        static let session = "session"
        static let id = "id"
        static let expiration = "expiration"

        static let account = "account"
        static let key = "key"
        static let registered = "registered"

    }

}