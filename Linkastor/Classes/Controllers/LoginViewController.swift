//
//  LoginViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            if let s = session {
                LinkastorAPIClient.loginWithTwitter(s.authToken, authSecret: s.authTokenSecret, callback: { (user, error) -> Void in
                    if let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    else if let e = error {
                        print(e)
                        let alert = UIAlertController(title: "Error",
                            message: e.localizedDescription,
                            preferredStyle: .Alert)

                        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(cancel)

                        self.showViewController(alert, sender: nil)
                    }
                })
            }
            else {
                if let e = error {
                    let alert = UIAlertController(title: "Error",
                        message: e.localizedDescription,
                        preferredStyle: .Alert)

                    let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(cancel)

                    self.showViewController(alert, sender: nil)
                }
            }
        })

        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }

}
