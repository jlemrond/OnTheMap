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

// MARK: AddPinViewCtonroller

class AddPinViewController: UIViewController, MKMapViewDelegate {


    // MARK: Variables
    var addPinDelegate: NavigationBarDelegate?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var weblinkTextField: UITextField!
    @IBOutlet weak var weblinkView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!

    var weblinkViewElements: [UIView]!

    var postPin: Pin!

    let userData = UdacityClient.sharedInstance
    typealias postKeys = ParseClient.ParameterKeys



    // MARK: Standard Load/Appear Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        mapView.delegate = self

        weblinkViewElements = [weblinkTextField, weblinkView, submitButton]

        for item in weblinkViewElements {
            item.hidden = true
        }

    }



    //   MARK: Functions

    /// Dismisses AddPinView Controller.
    @IBAction func cancelAddPin() {
        dismissViewControllerAnimated(true, completion: nil)
    }


    /// Search for region based on input entered into searchBar text field.
    /// Return the data to create a Pin on the MapView.
    @IBAction func searchForRegion() {

        guard !searchBar.text!.isEmpty else {
            displayOneButtonAlert("Alert", message: "Please enter text in Search Bar")
            return
        }

        acitivityIndicator.startAnimating()

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!) { (response, error) in
            guard error == nil else {
                if error?.code == 8 {
                    self.displayOneButtonAlert("Oops!", message: "Are you sure that's a real place?  We could not find it.\n\nWhy don't you try something different?")
                } else {
                    self.displayOneButtonAlert("Oops!", message: "Something bad happened")
                }

                performOnMain({
                    self.acitivityIndicator.stopAnimating()
                })

                print(error)
                return
            }

            let data = response![0]

            guard let coordinates = data.location?.coordinate else {
                
                performOnMain({
                    self.acitivityIndicator.stopAnimating()
                })

                self.displayOneButtonAlert("Alert", message: "No coordinates available")
                return
            }

            let regionRadius: CLLocationDistance = 2000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)

            self.postPin = Pin(placemark: data)

            performOnMain({
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.mapView.addAnnotation(self.postPin.locationAnnotation)
                self.acitivityIndicator.stopAnimating()
                for items in self.weblinkViewElements {
                    items.hidden = false
                }
            })
        }
    }


    /// Submit Pin to Parse to validate and add to database.
    @IBAction func submitPin() {

        performHighPriority {
            // Verify text field is not empty.
            guard !self.weblinkTextField.text!.isEmpty else {
                self.displayOneButtonAlert("Slow Down!", message: "Please add a link to your pin, before sumbitting!")
                return
            }

            guard let pinData = self.postPin else {
                self.displayOneButtonAlert("Oops!", message: "Data unavailable for pin")
                return
            }

            // Create Dictionary containing the JSON Keys and Values.
            let jsonData: [String: AnyObject] = [
                postKeys.uniqueKey: self.userData.accountKey!,
                postKeys.firstName: self.userData.firstName!,
                postKeys.lastName: self.userData.lastName!,
                postKeys.latitude: pinData.latitude,
                postKeys.longitude: pinData.longitude,
                postKeys.mediaURL: self.weblinkTextField.text!,
                postKeys.mapString: pinData.locationName ?? ""
            ]

            ParseClient.sharedInstance.postStudentLocations(jsonData) { (results, error) in
                guard error == nil  else {
                    self.displayOneButtonAlert("Error", message: error)
                    return
                }

                performOnMain({ 
                    self.addPinDelegate?.refreshData()
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
}



// MARK: - UITextField Delegate

extension AddPinViewController: UITextFieldDelegate {

    // Perform actions when Return is selected on keyboard based on the active
    // First Responder.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == searchBar {
            searchForRegion()
        }

        if textField == weblinkTextField {
            submitPin()
        }

        return true
    }

}
    