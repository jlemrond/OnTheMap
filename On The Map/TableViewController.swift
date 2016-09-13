//
//  TableViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/6/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

//  MARK: TableViewController
/// Class for controlling Pin data supplied by Parse in list TableView format.
class TableViewController: UIViewController {

    // MARK: Variables
    @IBOutlet weak var tableView: UITableView!

    let parse = ParseClient.sharedInstance

    // MARK: View Load/Appear Functions
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight = 60
    }

    override func viewWillAppear(animated: Bool) {
        performOnMain { 
            self.tableView.reloadData()
        }
    }

}

// MARK: - TableViewDelegate Methods

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: Number of Rows in Section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.sharedInstance.pins.count
    }

    // MARK: Cell for Row at IndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "TableViewCell")
        let cellData = StudentInformation.sharedInstance.pins[indexPath.item]

        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.mediaURL
        cell.imageView?.image = UIImage(named: "PinIcon")

        return cell
    }

    // MARK: Did Select Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let url = StudentInformation.sharedInstance.pins[indexPath.item].subtitle else {
            displayOneButtonAlert("Alert", message: "No URL available")
            return
        }

        let components = NSURLComponents(string: url)
        if components?.scheme == nil {
            components?.scheme = "https"
        }
        print(components?.URL)

        guard let fullPath = components?.URL else {
            displayOneButtonAlert("Alert", message: "Unable to access URL")
            return
        }

        UIApplication.sharedApplication().openURL(fullPath)
    }

}

// MARK: - NavigationBarDelegate Methods

extension TableViewController: NavigationBarDelegate {

    func refreshData() {
        performHighPriority {
            ParseClient.sharedInstance.getStudnetLocations { (results, error) in
                guard error == nil else {
                    self.displayOneButtonAlert("Error", message: error)
                    return
                }

                guard let results = results else {
                    self.displayOneButtonAlert("Alert", message: "No Results returned")
                    return
                }

                StudentInformation.sharedInstance.collectPins(results)
                performOnMain({
                    self.tableView.reloadData()
                })
            }
        }
    }

}
