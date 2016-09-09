//
//  NavigationBar.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/6/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationBarDelegate {
    func refreshData()
    func showAddPinView()
    func logout()
}

extension NavigationBarDelegate where Self: UIViewController {

    func showAddPinView() {
        print("Function Called: Show Add Pin View")

        guard let addPinViewController = storyboard?.instantiateViewControllerWithIdentifier("AddPinViewController") as? AddPinViewController else {
            displayOneButtonAlert("Error", message: "Unable to access Add Pin View")
            return
        }
        addPinViewController.addPinDelegate = self
        addPinViewController.modalPresentationStyle = .FullScreen
        presentViewController(addPinViewController, animated: true, completion: nil)

    }

    func logout() {
        print("Function Called: Logout")

        UdacityClient.sharedInstance.logout { (response, error) in
            guard error == nil else {
                self.displayOneButtonAlert("Error", message: error)
                return
            }

            UdacityClient.sharedInstance.sessionID = nil
            UdacityClient.sharedInstance.accountKey = nil
            UdacityClient.sharedInstance.firstName = nil
            UdacityClient.sharedInstance.lastName = nil
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }

}