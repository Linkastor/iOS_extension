//
//  LinkastorAPIClient.swift
//  Linkastor
//
//  Created by Thibaut LE LEVIER on 01/07/2015.
//  Copyright © 2015 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class LinkastorAPIClient {
    static let serverURL = "http://linkastor.com"
//    static let serverURL = "http://localhost:5000"

    class func loginWithTwitter(authToken: String!, authSecret: String!, callback: (user: AnyObject?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: serverURL + "/api/v1/users/sign_in")!)
        request.HTTPMethod = "post"
        request.HTTPBody = String("auth_token="+authToken+"&auth_secret="+authSecret).dataUsingEncoding(NSUTF8StringEncoding)

        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let d = data {
                do {
                    var user: AnyObject?
                    var serverError: NSError?

                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments) as? Dictionary<String, AnyObject> {

                        if let userJson = json["user"] as? Dictionary<String, AnyObject> {
                            user = userJson
                            SessionManager.sharedManager.user = userJson
                            if let authToken = userJson["auth_token"] as? String {
                                SessionManager.sharedManager.apiKey = authToken
                            }
                        }
                        else if let errorJson = json["error"] as? String {
                            serverError = NSError(domain: "com.linkastor", code: 403, userInfo: [NSLocalizedDescriptionKey : errorJson])
                        }
                    }

                    callback(user: user, error: serverError)
                } catch {
                    let e = error as NSError
                    callback(user: nil, error: e)
                }
                

            }
            else {
                callback(user: nil, error: error)
            }
        }

        task.resume()
    }

    class func getGroups(callback: (groups: [Dictionary<String, AnyObject>]?, error: NSError?) -> Void) {
        var urlString = serverURL + "/api/v1/groups"
        if let apiKey = SessionManager.sharedManager.apiKey {
            urlString += "?auth_token=" + apiKey
        }
        let request = NSURLRequest(URL: NSURL(string: urlString)!)

        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let d = data {
                var groups: [Dictionary<String, AnyObject>]?
                var serverError: NSError?
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments) as? Dictionary<String, AnyObject> {
                        if let groupsJson = json["groups"] as? [Dictionary<String, AnyObject>] {
                            groups = groupsJson
                        }
                        else if let errorJson = json["message"] as? String {
                            serverError = NSError(domain: "com.linkastor", code: 403, userInfo: [NSLocalizedDescriptionKey : errorJson])
                        }
                    }

                    callback(groups: groups, error: serverError)
                } catch {
                    let e = error as NSError
                    callback(groups: nil, error: e)
                }
            }
            else {
                callback(groups: nil, error: error)
            }

        }

        task.resume()
    }

    class func postLink(url: String, title: String, groupID: Int, callback: (error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: serverURL + "/api/v1/groups/" + String(groupID) + "/links")!)
        request.HTTPMethod = "post"
        var postBody = "link[title]=" + title + "&link[url]=" + url
        if let apiKey = SessionManager.sharedManager.apiKey {
            postBody += "&auth_token=" + apiKey
        }
        request.HTTPBody = String(postBody).dataUsingEncoding(NSUTF8StringEncoding)

        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let d = data {
                var serverError: NSError?
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments) as? Dictionary<String, AnyObject> {
                        if let errorJson = json["error"] as? String {
                            serverError = NSError(domain: "com.linkastor", code: 422, userInfo: [NSLocalizedDescriptionKey : errorJson])
                        }
                    }
                    callback(error: serverError)
                } catch {
                    let e = error as NSError
                    callback(error: e)
                }
            }
            else {
                callback(error: error)
            }

        }

        task.resume()

    }

}
