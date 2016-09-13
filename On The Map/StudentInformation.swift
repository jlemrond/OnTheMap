//
//  StudentInformation.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/13/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation

class StudentInformation {

    // Singleton Set Up
    static let sharedInstance = StudentInformation()

    // Pin Array
    var pins: [Pin] = []

    //  MARK: Collect Pins
    /// Collect Pins and store them in pins array
    func collectPins(data: [[String:AnyObject]]) -> [Pin] {

        pins = []

        for item in data {

            let pin = Pin(properties: item)
            pins.append(pin)

        }
        
        return pins
        
    }

}
