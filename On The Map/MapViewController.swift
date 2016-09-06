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

        performHighPriority { 
            self.parse.getStudnetLocations { (results, error) in
                guard error == nil else {
                    return
                }

                guard let results = results else {
                    return
                }

                let pinsArray = ParseClient.sharedInstance.collectPins(results)
                performOnMain({
                    self.mapView.addAnnotations(pinsArray)
                })
            }
        }

        performStandardPriority { 
            UdacityClient.sharedInstance.getUserData({ (error) in
                if error != nil {
                    print(error)
                }
            })
        }

    }

    @IBAction func test(sender: AnyObject) {

        print(UdacityClient.sharedInstance.firstName)



    }

}
