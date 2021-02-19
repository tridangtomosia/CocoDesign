//
//  MainRequest.swift
//  CoCoDesign
//
//  Created by apple on 2/18/21.
//

import Foundation

class MainRequest {
    static var shared = MainRequest()
    
    func request(url:String, method: String, params: [String: String], completion: ([AnyObject])->() ){
        if let nsURL = NSURL(string: url) {
            let request = NSMutableURLRequest(URL: nsURL)
            if method == "POST" {
                // convert key, value pairs into param string
                postString = params.map { "\($0.0)=\($0.1)" }.joinWithSeparator("&")
                request.HTTPMethod = "POST"
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            }
            else if method == "GET" {
                postString = params.map { "\($0.0)=\($0.1)" }.joinWithSeparator("&")
                request.HTTPMethod = "GET"
            }
            else if method == "PUT" {
                putString = params.map { "\($0.0)=\($0.1)" }.joinWithSeparator("&")
                request.HTTPMethod = "PUT"
                request.HTTPBody = putString.dataUsingEncoding(NSUTF8StringEncoding)
            }
            // Add other verbs here

            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) in
                do {

                    // what happens if error is not nil?
                    // That means something went wrong.

                    // Make sure there really is some data
                    if let data = data {
                        let response = try NSJSONSerialization.JSONObjectWithData(data, options:  NSJSONReadingOptions.MutableContainers)
                        completion(response)
                    }
                    else {
                        // Data is nil.
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
            // You could call the completion handler (callback) here with some value indicating an error
        }
    }
}
