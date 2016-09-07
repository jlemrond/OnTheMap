//
//  AppPinViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/7/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UITextField!

    @IBAction func cancelAddPin() {

        dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func searchForRegion() {

        guard let query = searchBar.text else {
            print("No Text in Search Field")
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { (response, error) in
            guard error == nil else {
                print("error with request")
                return
            }

            let data = response![0]

            guard let coordinates = data.location?.coordinate else {
                print("No Coordinates Returned")
                return
            }

            let regionRadius: CLLocationDistance = 2000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
        }

//        guard let query = searchBar.text else {
//            print("No Text in Search Field")
//            return
//        }
//
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = query
//        let search = MKLocalSearch(request: request)
//        search.startWithCompletionHandler { (response, error) in
//            guard error == nil else {
//                print("Error with Search")
//                return
//            }
//
//            guard let response = response else {
//                print("No Response Available")
//                return
//            }
//
//            mapView.addAnnotation(response.mapItems.placemark())
//
//            print(response.mapItems)
//        }

    }

}
    