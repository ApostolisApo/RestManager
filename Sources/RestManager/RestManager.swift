//
//  RestManager.swift
//  GoPump
//
//  Created by Apostolos Apostolidis on 2019-06-30.
//  Copyright © 2019 Apostolos Apostolidis. All rights reserved.
//

import Foundation

enum Timeouts: Double {
    case normal = 15.0
    case fast = 3.0
    case forced = 0.01
}


class RestManager: NSObject {
    var requestTimeout: Timeouts
    var urlSession: URLSession
    
    override init() {
        self.requestTimeout = .normal
        self.urlSession = URLSession(configuration: .default)
        super.init()
    }
    
    func async(get url: URL, withTimeout timeout: Timeouts?, andDo callback: @escaping (_ response: Data) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeout?.rawValue ?? Timeouts.normal.rawValue
        let dataTask = self.urlSession.dataTask(with: request) { (data, response, error) in
            if let returnedData = data {
                callback(returnedData)
            }
            else {
                print(error.debugDescription)
            }
        }
        dataTask.resume()
    }
    
    func downloadImage(from url: String, andDo callback: @escaping (_ data: Data?) -> Void) {
        guard let urlObj = URL(string: url)
            else {
                callback(nil)
                return
        }
        
        getData(from: urlObj) { data, response, error in
            callback(data)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 4.0
        configuration.timeoutIntervalForRequest = 3.0
        let session = URLSession(configuration: configuration)
        session.dataTask(with: url, completionHandler: completion).resume()
    }
}
