//
//  StudentInformation.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/13/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation

class Pins {

    // Singleton Set Up
    static let sharedInstance = Pins()

    // Pin Array
    var pins: [StudentInformation] = []

    //  MARK: Collect Pins
    /// Collect Pins and store them in pins array
    func collectPins(data: [[String:AnyObject]]) -> [StudentInformation] {

        pins = []

        for item in data {

            let pin = StudentInformation(properties: item)
            pins.append(pin)

        }
        
        return pins
        
    }

}
