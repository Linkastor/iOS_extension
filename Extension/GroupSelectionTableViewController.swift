//
//  GroupSelectionTableViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 30/06/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

protocol GroupSelectionTableViewControllerDelegate {
    func userDidSelectAGroup(group: Dictionary<String, AnyObject>)
}

class GroupSelectionTableViewController: UITableViewController {

    let cellIdentifier = "cellIdentifier"
    var groups = [Dictionary<String, AnyObject>]() {
        didSet {
            self.tableView.reloadData()
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
        }
    }
    var delegate :GroupSelectionTableViewControllerDelegate?

    override init(style: UITableViewStyle) {
        super.init(style: style)

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let groups = SessionManager.sharedManager.groups {
            self.groups = groups
        }
        else {
            self.refreshGroups(nil)
        }

        self.title = "Select a group"

        self.tableView.backgroundColor = UIColor.clearColor()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshGroups:", forControlEvents: .ValueChanged)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let group = self.groups[indexPath.row]

        if let name = group["name"] as? String {
            if let label = cell.textLabel {
                label.text = name
            }
        }

        if let groupID = group["id"] as? Int {
            if let selectedGroup = SessionManager.sharedManager.selectedGroup {
                if let selectedGroupID = selectedGroup["id"] as? Int {
                    if groupID == selectedGroupID {
                        cell.accessoryType = .Checkmark
                    }
                }
            }
        }

        cell.backgroundColor = UIColor.clearColor()

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = self.groups[indexPath.row]
        if let d = self.delegate {
            d.userDidSelectAGroup(group)
        }

        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    // MARK: - refresh
    func refreshGroups(sender: AnyObject?) {
        LinkastorAPIClient.getGroups { (groups, error) -> Void in
            if let g = groups {
                self.groups = g
                SessionManager.sharedManager.groups = g
            }

        }
    }

}
