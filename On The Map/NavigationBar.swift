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

        guard let addPinViewController = storyboard?.instantiateViewControllerWithIdentifier("AddPinViewController") as? AddPinViewController else {
            print("Unable to Access AddPinViewController")
            return
        }
        addPinViewController.addPinDelegate = self
        addPinViewController.modalPresentationStyle = .FullScreen
        presentViewController(addPinViewController, animated: true, completion: nil)

    }

    func logout() {
        print("Function Called: Logout")

        UdacityClient.sharedInstance.logout { (response, error) in
            print(response)
        }

    }

}