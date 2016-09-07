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

extension UIViewController {

    func showAddPinView() {

        guard let addPinViewController = storyboard?.instantiateViewControllerWithIdentifier("AddPinViewController") else {
            print("Unable to Access AddPinViewController")
            return
        }
        addPinViewController.modalPresentationStyle = .FullScreen
        presentViewController(addPinViewController, animated: true, completion: nil)

    }

    func logout() {

        print("logout")
    }

}