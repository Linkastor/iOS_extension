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
        if let context = self.extensionContext {
            if let item = context.inputItems.first {
                if let attachments = item.attachments {
                    if let provider = attachments!.first as? NSItemProvider {
                        if provider.hasItemConformingToTypeIdentifier("public.url") {
                            provider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (url, error) -> Void in
                                if let u = url as? NSURL {
                                    if let selectedGroup = SessionManager.sharedManager.selectedGroup {
                                        if let groupID = selectedGroup["id"] as? Int {
                                            LinkastorAPIClient.postLink(u.absoluteString, title: self.contentText, groupID: groupID, callback: { (error) -> Void in
                                                if let e = error {
                                                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .Alert)

                                                    let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
                                                        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                                                    })
                                                    alert.addAction(cancel)
                                                    
                                                    self.showViewController(alert, sender: nil)
                                                }
                                                else {
                                                    self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                                                }
                                            })
                                        }
                                    }



                                }
                            })
                        }
                    }

                }
            }
        }


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
    }
}
