//
//  GroupsTableViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

protocol GroupsTableViewControllerDelegate {
    func userDidSelectAGroup(group: Dictionary<String, AnyObject>)
}

class GroupsTableViewController: UITableViewController {

    var groups = [Dictionary<String, AnyObject>]()
    var delegate :GroupsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your groups"
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groups.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath)

        let group = self.groups[indexPath.row]

        if let name = group["name"] as? String {
            if let label = cell.textLabel {
                label.text = name
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = self.groups[indexPath.row]
        if let d = self.delegate {
            d.userDidSelectAGroup(group)
        }

        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
}
