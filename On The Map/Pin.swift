//
//  Pin.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/4/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {

    let longitude: Float
    let latitude: Float
    let objectID: String
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let uniqueKey: String?
    let locationName: String?

    var title: String? {

        let first: String = (firstName != nil) ? firstName! : ""
        let last: String = (lastName != nil) ? lastName! : ""

        return first + last

    }

    var subtitle: String? {
        return mediaURL
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(longitude), longitude: Double(latitude))
    }

    init(properties: [String: AnyObject]) {

        typealias key = ParseClient.PinData;

        longitude = properties[key.longitude] as? Float ?? 0
        latitude = properties[key.latitude] as? Float ?? 0
        objectID = properties[key.objectID] as! String
        firstName = properties[key.firstName] as? String
        lastName = properties[key.lastName] as? String
        mediaURL = properties[key.mediaURL] as? String
        uniqueKey = properties[key.uniqueKey] as? String
        locationName = properties[key.mapString] as? String

    }

    func printName() {
        print(title)
    }

}