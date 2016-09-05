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

    let parse = ParseClient.sharedInstance

    override func viewDidLoad() {
        mapView.delegate = self
    }

    @IBAction func test(sender: AnyObject) {

        // let pin = MKPointAnnotation()

    }

}
