//
//  TableViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/6/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let parse = ParseClient.sharedInstance

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight = 60
    }

}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(ParseClient.sharedInstance.pins.count)
        return ParseClient.sharedInstance.pins.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "TableViewCell")
        let cellData = ParseClient.sharedInstance.pins[indexPath.item]

        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.mediaURL
        cell.imageView?.image = UIImage(named: "PinIcon")

        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let url = ParseClient.sharedInstance.pins[indexPath.item].subtitle else {
            return
        }

        let components = NSURLComponents(string: url)
        if components?.scheme == nil {
            components?.scheme = "https"
        }
        print(components?.URL)

        guard let fullPath = components?.URL else {
            return
        }

        UIApplication.sharedApplication().openURL(fullPath)
    }

}

extension TableViewController: NavigationBarDelegate {

    func refreshData() {
        performHighPriority {
            ParseClient.sharedInstance.getStudnetLocations { (results, error) in
                guard error == nil else {
                    return
                }

                guard let results = results else {
                    return
                }

                ParseClient.sharedInstance.collectPins(results)
                performOnMain({
                    self.tableView.reloadData()
                })
            }
        }
    }

}
