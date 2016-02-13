//
//  NSExtensionContext+ContextHelper.swift
//  Extension
//
//  Created by Thibaut LE LEVIER on 13/02/2016.
//  Copyright © 2016 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

extension NSExtensionContext {
    func URLForContext(withCallback callback: (url: NSURL?) -> Void) {

        let identifier = "public.url"

        var item: NSItemProvider?

        let inputItems = self.inputItems as! [NSExtensionItem]
        for inputItem in inputItems {
            let attachements = inputItem.attachments as! [NSItemProvider]
            for itemProvider in attachements {
                if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
                    item = itemProvider
                    break
                }
            }

        }

        if let i = item {
            i.loadItemForTypeIdentifier(identifier, options: nil, completionHandler: { (value, error) -> Void in
                callback(url: value as? NSURL)
            })
        }
        else {

            // no url, let's try to parse the plain-text body and look for one
            self.URLFromPlainText(withCallback: { (url) -> Void in
                callback(url: url)
            })
        }
    }

    func URLFromPlainText(withCallback callback: (url: NSURL?) -> Void) {

        let identifier = "public.plain-text"

        var item: NSItemProvider?

        let inputItems = self.inputItems as! [NSExtensionItem]
        for inputItem in inputItems {
            let attachements = inputItem.attachments as! [NSItemProvider]
            for itemProvider in attachements {
                if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
                    item = itemProvider
                    break
                }
            }
            
        }

        if let i = item {
            i.loadItemForTypeIdentifier(identifier, options: nil, completionHandler: { (value, error) -> Void in
                var returnURL: NSURL?

                if let text = value as? String {
                    do {
                        let expression = try NSRegularExpression(pattern: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", options: .CaseInsensitive)
                        if let result = expression.firstMatchInString(text, options: .ReportCompletion, range: NSMakeRange(0, text.characters.count)) {
                            let urlString = (text as NSString).substringWithRange(result.range) as String
                            returnURL = NSURL(string: urlString)
                        }
                    } catch {

                    }
                }

                callback(url: returnURL)
            })
        }


    }
}
