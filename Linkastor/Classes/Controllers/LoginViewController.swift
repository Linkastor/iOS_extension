//
//  LoginViewController.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 02/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit
import TwitterKit
import MBProgressHUD

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession?, error: NSError?) -> Void in
            if let s = session {
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                LinkastorAPIClient.loginWithTwitter(s.authToken, authSecret: s.authTokenSecret, callback: { (user, error) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    else if let e = error {
                        print(e)
                        let alert = UIAlertController(title: "Linkastor Login Error",
                            message: e.localizedDescription,
                            preferredStyle: .Alert)

                        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(cancel)

                        self.showViewController(alert, sender: nil)
                    }
                })
            }
            else {
                let alert = UIAlertController(title: "Twitter Login Error",
                    message: error?.localizedDescription,
                    preferredStyle: .Alert)

                let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(cancel)

                self.showViewController(alert, sender: nil)
            }
        })

        var center = self.view.center
        center.y = self.view.frame.size.height - logInButton.frame.size.height * 2
        logInButton.center = center
        self.view.addSubview(logInButton)

    }

}
