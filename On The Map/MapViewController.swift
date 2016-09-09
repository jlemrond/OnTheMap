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

// MARK: MapViewController, NavigationBarDelegate

class MapViewController: UIViewController, NavigationBarDelegate {


    // MARK: Variables

    @IBOutlet weak var mapView: MKMapView!


    //MARK: Standard Load/Appear Functions

    override func viewDidLoad() {
        mapView.delegate = self

        setUpNavigationBar()

        addPinsToMap()

        performStandardPriority { 
            UdacityClient.sharedInstance.getUserData({ (error) in
                if error != nil {
                    self.displayOneButtonAlert("Alert", message: error)
                }
            })
        }
    }

    override func viewWillAppear(animated: Bool) {
        performOnMain { 
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(ParseClient.sharedInstance.pins)
        }
    }


    // MARK: Functions

    /// Collects Data from Parse and Adds Pins to Map
    func addPinsToMap() {
        print("Function Called: Add Pins to Map")

        performHighPriority {
            ParseClient.sharedInstance.getStudnetLocations { (results, error) in
                guard error == nil else {
                    self.displayOneButtonAlert("Error", message: error)
                    return
                }

                guard let results = results else {
                    self.displayOneButtonAlert("Alert", message: "No Results Returned")
                    return
                }

                let pinsArray = ParseClient.sharedInstance.collectPins(results)
                performOnMain({
                    self.mapView.addAnnotations(pinsArray)
                })
            }
        }
    }


    /// NavigationBar UI Setup
    func setUpNavigationBar() {
        print("Setting Up Navigation Bar")

        tabBarController?.navigationItem.title = "On The Map"

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refreshData))
        let addButton = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .Plain, target: self, action: #selector(performShowAddPinView))

        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(performLogout))

        tabBarController?.navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: true)
        tabBarController?.navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
        
    }


    /// Refresh Data
    func refreshData() {
        print("Refresh Data Called")
        mapView.removeAnnotations(mapView.annotations)
        addPinsToMap()
    }
    
    // MARK: Perform Selector Method Functions
    //
    // 'Perform' functions used to allow #selectors to execute
    // protocol methods from the NavigationBarDelegate.
    //
    // Appears to be a bug.
    //
    // https://forums.developer.apple.com/message/49465#49465
    func performLogout() {
        logout()
    }

    func performShowAddPinView() {
        showAddPinView()
    }
}
