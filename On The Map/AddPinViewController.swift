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

class AddPinViewController: UIViewController, MKMapViewDelegate {

    var addPinDelegate: NavigationBarDelegate?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var weblinkTextField: UITextField!
    @IBOutlet weak var weblinkView: UIView!
    @IBOutlet weak var submitButton: UIButton!

    var weblinkViewElements: [UIView]!

    var postPin: Pin!

    let userData = UdacityClient.sharedInstance
    typealias postKeys = ParseClient.ParameterKeys

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        mapView.delegate = self

        weblinkViewElements = [weblinkTextField, weblinkView, submitButton]

        for item in weblinkViewElements {
            item.hidden = true
        }

    }

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

            self.postPin = Pin(placemark: data)

            performOnMain({
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.mapView.addAnnotation(self.postPin)
                for items in self.weblinkViewElements {
                    items.hidden = false
                }
            })

        }

    }

    @IBAction func submitPin() {

        guard !(weblinkTextField.text!.isEmpty) else {
            print("Please add a link to your pin.")
            return
        }

        guard let pinData = postPin else {
            print("No Data for Pin")
            return
        }

        let jsonData: [String: AnyObject] = [
            postKeys.uniqueKey: userData.accountKey!,
            postKeys.firstName: userData.firstName!,
            postKeys.lastName: userData.lastName!,
            postKeys.latitude: pinData.latitude,
            postKeys.longitude: pinData.longitude,
            postKeys.mediaURL: weblinkTextField.text!,
            postKeys.mapString: pinData.locationName!
        ]

        ParseClient.sharedInstance.postStudentLocations(jsonData) { (results, error) in
            guard error == nil  else {
                print("Error: unable to post Pin")
                return
            }

            self.addPinDelegate?.refreshData()
            self.dismissViewControllerAnimated(true, completion: nil)

        }

    }

}


extension AddPinViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == searchBar {
            searchForRegion()
        }

        return true
    }

}
    