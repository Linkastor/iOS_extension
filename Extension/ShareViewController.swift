//
//  ShareViewController.swift
//  Extension
//
//  Created by Thibaut LE LEVIER on 30/06/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController, GroupSelectionTableViewControllerDelegate {

    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()

        guard let _ = SessionManager.sharedManager.apiKey else {

            let alert = UIAlertController(title: "Error", message: "Please log in the Linkastor app first", preferredStyle: .Alert)

            let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            })
            alert.addAction(cancel)

            let openApp = UIAlertAction(title: "Open Linkastor", style: .Default, handler: { (action) -> Void in
                let url = NSURL(string: "linkastor://")!
                var responder: UIResponder? = self
                while let r = responder {
                    if r.respondsToSelector("openURL:") {
                        r.performSelector("openURL:", withObject: url)
                        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                        break
                    }
                    responder = r.nextResponder()
                }
            })

            alert.addAction(openApp)

            self.showViewController(alert, sender: nil)



            return
        }
    }
    
    override func isContentValid() -> Bool {
        if let _ = SessionManager.sharedManager.selectedGroup {
            return true
        }

        return false
    }

    override func didSelectPost() {

        self.extensionContext?.URLForContext(withCallback: { (url) -> Void in
            if let u = url {
                LinkastorAPIClient.postLink(u.absoluteString,
                    title: self.contentText,
                    groupID: SessionManager.sharedManager.selectedGroupID!,
                    callback: { (error) -> Void in
                        if let e = error {
                            let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .Alert)

                            let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
                                self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
                            })
                            alert.addAction(cancel)

                            self.showViewController(alert, sender: nil)
                        }
                        else {
                            self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
                        }
                })
            }
            else {
                let alert = UIAlertController(title: "Error",
                    message: "Cannot find any URL in the content you are trying to share", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
                    self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
                })
                alert.addAction(cancel)

                self.showViewController(alert, sender: nil)
            }
        })

    }

    override func configurationItems() -> [AnyObject]! {
        return [groupConfigurationItem]
    }

    lazy var groupConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item.title = "Group"
        if let selectedGroup = SessionManager.sharedManager.selectedGroup {
            if let groupName = selectedGroup["name"] as? String {
                item.value = groupName
            }
        }
        else {
            item.value = "[Select a group]"
        }
        item.tapHandler = self.showGroupSelection
        return item
    }()

    func showGroupSelection() {
        let groupViewController = GroupSelectionTableViewController(style: .Plain)
        groupViewController.delegate = self
        pushConfigurationViewController(groupViewController)
    }

    // MARK: GroupSelectionTableViewControllerDelegate
    func userDidSelectAGroup(group: Dictionary<String, AnyObject>) {
        SessionManager.sharedManager.selectedGroup = group
        if let groupName = group["name"] as? String {
            self.groupConfigurationItem.value = groupName
        }
        self.validateContent()
    }
}
