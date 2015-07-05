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
    var groups = [Dictionary<String, AnyObject>]()
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

        self.title = "Select a group"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
