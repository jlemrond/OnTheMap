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

    var longitude: Float
    var latitude: Float
    var objectID: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var uniqueKey: String?
    var locationName: String?

    var title: String? {

        let first: String = (firstName != nil) ? "\(firstName!) " : ""
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
        objectID = properties[key.objectID] as? String
        firstName = properties[key.firstName] as? String
        lastName = properties[key.lastName] as? String
        mediaURL = properties[key.mediaURL] as? String
        uniqueKey = properties[key.uniqueKey] as? String
        locationName = properties[key.mapString] as? String

    }

    init(placemark: CLPlacemark) {
        let coordinate = placemark.location!.coordinate
        longitude = Float(coordinate.longitude)
        latitude = Float(coordinate.latitude)
        locationName = placemark.locality
        firstName = "Jason"
        lastName = "Lemrond"
    }

    init(coordinate: CLLocationCoordinate2D) {
        longitude = Float(coordinate.longitude)
        latitude = Float(coordinate.latitude)
        firstName = "Jason"
        lastName = "Lemrond"
    }

}