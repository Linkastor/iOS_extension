//
//  ShareViewController.swift
//  Extension
//
//  Created by Thibaut LE LEVIER on 30/06/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        let group = SLComposeSheetConfigurationItem()
        group.title = "Group"
        group.value = "Test"
        group.tapHandler = showGroupSelection

        return [group]
    }

    func showGroupSelection() {
        let groupViewController = GroupSelectionTableViewController(style: .Plain)

        pushConfigurationViewController(groupViewController)
    }

}
