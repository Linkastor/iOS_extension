//
//  HomeViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, GroupsTableViewControllerDelegate {

    @IBOutlet weak var urlField :UITextField!
    @IBOutlet weak var titleField :UITextField!
    @IBOutlet weak var groupButton :UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.groupButton.setTitle("Select a group ->", forState: .Normal)
        if let group = SessionManager.sharedManager.selectedGroup {
            if let name = group["name"] as? String {
                self.groupButton.setTitle(name, forState: .Normal)
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = SessionManager.sharedManager.apiKey {
            LinkastorAPIClient.getGroups({ (groups, error) -> Void in
                if let g = groups {
                    SessionManager.sharedManager.groups = g
                }
                else if let _ = error {
                    SessionManager.logout()
                    self.performSegueWithIdentifier("showLogin", sender: nil)
                }
            })
        }
        else {
            self.performSegueWithIdentifier("showLogin", sender: nil)
        }
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGroups" {
            if let controller = segue.destinationViewController as? GroupsTableViewController {
                if let groups = SessionManager.sharedManager.groups {
                    controller.groups = groups
                    controller.delegate = self
                }
            }
        }
    }

    // MARK: GroupsTableViewControllerDelegate

    func userDidSelectAGroup(group: Dictionary<String, AnyObject>) {
        SessionManager.sharedManager.selectedGroup = group
        if let name = group["name"] as? String {
            self.groupButton.setTitle(name, forState: .Normal)
        }
    }

    // MARK: Action

    @IBAction func postAction(sender: AnyObject) {

        self.urlField.resignFirstResponder()
        self.titleField.resignFirstResponder()

        var alertMessage :String?

        if let url = self.urlField.text {
            if url.characters.count == 0 {
                alertMessage = "URL must be filed"
            }
            else {
                if let title = self.titleField.text {
                    if title.characters.count == 0 {
                        alertMessage = "Title must be filed"
                    }
                    else {
                        if let group = SessionManager.sharedManager.selectedGroup {
                            if let groupID = group["id"] as? Int {
                                LinkastorAPIClient.postLink(url, title: title, groupID: groupID, callback: { (error) -> Void in
                                    if let e = error {
                                        let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .Alert)
                                        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                                        alert.addAction(cancel)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    else {
                                        alertMessage = "Link posted"
                                        self.urlField.text = nil
                                        self.titleField.text = nil
                                    }
                                })
                            }

                        }
                        else {
                            alertMessage = "Select a group first"
                        }
                    }
                }
            }
        }

        if let message = alertMessage {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
