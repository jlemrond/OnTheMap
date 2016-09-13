//
//  ParseClient.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/4/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import MapKit

class ParseClient: NSObject, Networkable {

    // Singleton Set Up
    static let sharedInstance = ParseClient()
    override init() {
        super.init()
    }

    // Shared Session
    let session = NSURLSession.sharedSession()

    // MARK: - Get Student Locations
    /// Get last 100 Pins entered into the Parse Database.
    func getStudnetLocations(completion: (results: [[String: AnyObject]]?, error: String?) -> Void) {

        // Reset Array of Pins
        StudentInformation.sharedInstance.pins = []

        let url = NSURL(string: URL.fullPath)

        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Keys.applicationID, forHTTPHeaderField: HeaderFields.applicationID)
        request.addValue(Keys.api, forHTTPHeaderField: HeaderFields.api)

        makeAPIRequest(request) { (result, error) in

            guard let jsonData = result else {
                completion(results: nil, error: error?.localizedDescription)
                return
            }

            guard let results = jsonData[ResponseKeys.results] as? [[String: AnyObject]] else {
                completion(results: nil, error: "No results returned")
                return
            }

            completion(results: results, error: nil)
        }
    }

    //  MARK: Post Student Locations
    /// Add Student pins to Parse Database.
    func postStudentLocations(parameters: [String: AnyObject], completion: (results: AnyObject?, error: String?) -> Void) {

        guard let request = buildParseRequest(.postStudentLocation) else {
            completion(results: nil, error: "Unable to create request")
            return
        }

        let jsonString = createJSONString(parameters)

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)

        makeAPIRequest(request) { (result, error) in
            guard let result = result else {
                completion(results: nil, error: "No Data Returned")
                return
            }

            completion(results: result, error: nil)
        }


    }


    // MARK: -

    // MARK: Parse JSON Data
    func parseJSONData(data: NSData) -> AnyObject? {

        var jsonData: AnyObject!
        do {
            jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            print("Unable to deserialize JSON data")
            return nil
        }

        print("JSON Data parsed: \n\(jsonData)")

        return jsonData

    }

    //  MARK: Create JSON String
    /// Create a String from a dictionary containing JSON Data for POST Headers
    func createJSONString(jsonData: [String: AnyObject]) -> String? {

        // Validate data supplied is can be converted to JSON.
        guard (NSJSONSerialization.isValidJSONObject(jsonData)) else {
            print("Not a valid JSON Object")
            return nil
        }

        // Convert data to JSON.
        let jsonObject: NSData
        do {
            jsonObject = try NSJSONSerialization.dataWithJSONObject(jsonData, options: .PrettyPrinted)
        } catch {
            print("Unable to create JSON Object")
            return nil
        }

        // Convert JSON Data into a string.
        guard let jsonString = NSString(data: jsonObject, encoding: NSUTF8StringEncoding) else {
            print("Unable to create string from JSON Object")
            return nil
        }

        print("JSON String: \(jsonString)")
        return String(jsonString)

    }

    //  MARK: Build URL
    /// Build URL Request based on method provided.
    func buildParseRequest(method: ParseClient.method) -> NSMutableURLRequest? {

        var urlString: String
        switch method {
        case .getStudentLocation:
            urlString = URL.fullPath + "?limit=100&order=-updatedAt"
        case .postStudentLocation:
            urlString = URL.fullPath
        }

        guard let url = NSURL(string: urlString) else {
            return nil
        }

        let request = NSMutableURLRequest(URL: url)
        request.addValue(Keys.applicationID, forHTTPHeaderField: HeaderFields.applicationID)
        request.addValue(Keys.api, forHTTPHeaderField: HeaderFields.api)

        return request

    }


}

// MARK: - Parse Constants
extension ParseClient {

    // MARK: Keys
    struct Keys {
        static let api = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }

    // MARK: Header Fields
    struct HeaderFields {
        static let applicationID = "X-Parse-Application-Id"
        static let api = "X-Parse-REST-API-Key"
    }

    // MARK: API URL
    struct URL {
        static let fullPath = "https://parse.udacity.com/parse/classes/StudentLocation"
    }

    // MARK: Methods
    enum method: String {
        case getStudentLocation
        case postStudentLocation
    }

    // MARK: Response Keys
    struct ResponseKeys {
        static let results = "results"
    }

    // MARK: Pin Data
    struct PinData {
        static let longitude = "longitude"
        static let latitude = "latitude"
        static let objectID = "objectId"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mediaURL = "mediaURL"
        static let uniqueKey = "uniqueKey"
        static let mapString = "mapString"
        static let updatedAt = "updatedAt"
    }

    // MARK: Parameter Values
    struct ParameterKeys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }

}
