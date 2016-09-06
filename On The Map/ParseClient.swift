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

    // Pin Array
    var pins: [Pin] = []

    // MARK: - Get Student Locations
    func getStudnetLocations(completion: (results: [[String: AnyObject]]?, error: String?) -> Void) {

        // Reset Array of Pins
        pins = []

        let url = buildParseURL(.getStudentLocation, parameters: nil)

        let request = NSMutableURLRequest(URL: url)
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

        return jsonData

    }

    // MARK: Collect Pins
    // Collect Pins and store them in pins array
    func collectPins(data: [[String:AnyObject]]) -> [MKAnnotation] {

        pins = []

        for (_, item) in data.enumerate() {

            let pin = Pin(properties: item)
            pins.append(pin)

        }

        return pins

    }

    // MARK: Build URL
    // Build URL based on method used provided
    func buildParseURL(method: ParseClient.method, parameters: [String: String]?) -> NSURL {

        var urlString = URL.fullPath
        if method == .getStudentLocation {
            urlString = URL.fullPath + "?limit=100"
        }

        return NSURL(string: urlString)!

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
    }

}
