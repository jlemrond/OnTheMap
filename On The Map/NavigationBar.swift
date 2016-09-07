//
//  NavigationBar.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/6/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

//protocol Navigatable {
//
//    func setUpNavigationBar()
//
//}
//
//extension Navigatable where Self: UIViewController {
//
//    func setUpNavigationBar() {
//        print("Setting Up Navigation Bar")
//
//        tabBarController?.navigationItem.title = "On The Map"
//
//        let refreshButton = UIBarButtonItem(image: UIImage(named: "MapIcon"), style: .Plain, target: self, action: #selector(refreshData))
//        let addButton = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .Plain, target: self, action: #selector(addPin))
//
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
//
//        tabBarController?.navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: true)
//        tabBarController?.navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
//
//    }
//
//}


//extension UIViewController where Self: Navigatable {
//
//    func setUpNavigationBar() {
//        print("Setting Up Navigation Bar")
//
//        tabBarController?.navigationItem.title = "On The Map"
//
//        let refreshButton = UIBarButtonItem(image: UIImage(named: "MapIcon"), style: .Plain, target: self, action: #selector(refreshData))
//        let addButton = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .Plain, target: self, action: #selector(addPin))
//
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
//
//        tabBarController?.navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: true)
//        tabBarController?.navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
//        
//    }
//
//}

protocol NavigationBarDelegate {
    func refreshData()
    func addPin()
    func logout()
}

extension UIViewController {

    func addPin() {

        print("add")

    }

    func logout() {

        print("logout")
    }

}