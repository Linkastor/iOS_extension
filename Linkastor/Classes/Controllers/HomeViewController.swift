//
//  HomeViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var nameLabel :UILabel!

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

            if let user = SessionManager.sharedManager.user {
                if let name = user["name"] as? String {
                    self.nameLabel.text = name
                }
            }
        }
        else {
            self.performSegueWithIdentifier("showLogin", sender: nil)
        }
    }

    // MARK: - 
    @IBAction func logoutAction(sender: AnyObject) {
        SessionManager.logout()
        self.performSegueWithIdentifier("showLogin", sender: nil)
    }

}
