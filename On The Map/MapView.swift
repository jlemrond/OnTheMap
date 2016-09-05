//
//  MapView.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/5/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        if !parse.pinsLoaded {
            parse.pinsLoaded = true
            ParseClient.sharedInstance.getStudnetLocations()
        }
    }

}
