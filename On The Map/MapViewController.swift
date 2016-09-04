//
//  MapViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/4/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBAction func test(sender: AnyObject) {

        UdacityClient.sharedInstance.getUserData { (error) in
            print("Completion")
        }

    }

}
