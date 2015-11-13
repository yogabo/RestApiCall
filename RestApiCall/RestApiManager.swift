//
//  RestApiManager.swift
//
//  Created by Lubos Sytensky on 13/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()

    let baseURL = "http://api.randomuser.me/"

    func getRandomUser(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }

    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)

        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }

    //MARK: Perform a POST Request
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        //var err: NSError?
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        // Set the POST body for the request
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: [])
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                let json:JSON = JSON(data: data!)
                onCompletion(json, error)
            })
            task.resume()
        } catch {
            print("error:\(error)")
        }
    }

}