//
//  Pin.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/4/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import MapKit

/// Object used to store data for Pins.
struct StudentInformation {

    var longitude: Float
    var latitude: Float
    var objectID: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var uniqueKey: String?
    var locationName: String?
    var updatedAt: String

    var title: String? {

        let first: String = (firstName != nil) ? "\(firstName!) " : ""
        let last: String = (lastName != nil) ? lastName! : ""

        return first + last

    }

    var subtitle: String? {
        return mediaURL
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
    }

    var locationAnnotation: MKPointAnnotation {

        let point = MKPointAnnotation()
        point.coordinate = self.coordinate
        point.title = self.title
        point.subtitle = self.subtitle

        return point
    }

    init(properties: [String: AnyObject]) {

        typealias key = ParseClient.PinData;

        longitude = properties[key.longitude] as? Float ?? 0
        latitude = properties[key.latitude] as? Float ?? 0
        objectID = properties[key.objectID] as? String
        firstName = properties[key.firstName] as? String
        lastName = properties[key.lastName] as? String
        mediaURL = properties[key.mediaURL] as? String
        uniqueKey = properties[key.uniqueKey] as? String
        locationName = properties[key.mapString] as? String
        updatedAt = properties[key.updatedAt] as! String

        print(updatedAt)

    }

    init(placemark: CLPlacemark) {
        let coordinate = placemark.location!.coordinate
        longitude = Float(coordinate.longitude)
        latitude = Float(coordinate.latitude)
        locationName = placemark.locality
        updatedAt = String(NSDate())

        print(updatedAt)
    }

}