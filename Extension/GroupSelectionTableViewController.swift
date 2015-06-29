//
//  GroupSelectionTableViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 30/06/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class GroupSelectionTableViewController: UITableViewController {

    let cellIdentifier = "cellIdentifier"

    override init(style: UITableViewStyle) {
        super.init(style: style)

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select a group"
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        cell.textLabel!.text = "Test"

        return cell
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
