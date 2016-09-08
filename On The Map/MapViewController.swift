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

class MapViewController: UIViewController, NavigationBarDelegate {

    @IBOutlet weak var mapView: MKMapView!

    static let sharedInstance = MapViewController()

    override func viewDidLoad() {
        mapView.delegate = self

        setUpNavigationBar()

        addPinsToMap()

        performStandardPriority { 
            UdacityClient.sharedInstance.getUserData({ (error) in
                if error != nil {
                    print(error)
                }
            })
        }

    }

    func clearPins() {
        mapView.removeAnnotations(mapView.annotations)
    }

    func addPinsToMap() {
        performHighPriority {
            ParseClient.sharedInstance.getStudnetLocations { (results, error) in
                guard error == nil else {
                    return
                }

                guard let results = results else {
                    return
                }

                let pinsArray = ParseClient.sharedInstance.collectPins(results)
                performOnMain({
                    self.mapView.addAnnotations(pinsArray)
                    print(self.mapView.annotations)
                })
            }
        }
    }

    func setUpNavigationBar() {
        print("Setting Up Navigation Bar")

        tabBarController?.navigationItem.title = "On The Map"

        let refreshButton = UIBarButtonItem(image: UIImage(named: "MapIcon"), style: .Plain, target: self, action: #selector(refreshData))
        let addButton = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .Plain, target: self, action: #selector(showAddPinView))

        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))

        tabBarController?.navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: true)
        tabBarController?.navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
        
    }

    func refreshData() {
        clearPins()
        addPinsToMap()
    }
}
