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

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(openSafari))
        view.addGestureRecognizer(gesture)
    }

    func openSafari(sender: UITapGestureRecognizer) {

        guard let annotationView = sender.view as? MKPinAnnotationView,
            let url = annotationView.annotation?.subtitle,
            let link = url else {
                displayOneButtonAlert("Error", message: "Unable to access web page url")
                return
        }

        let components = NSURLComponents(string: link)
        if components?.scheme == nil {
            components?.scheme = "https"
        }

        guard let fullPath = components?.URL else {
            displayOneButtonAlert("Error", message: "Unable to access web page url")
            return
        }

        UIApplication.sharedApplication().openURL(fullPath)
    }

}
