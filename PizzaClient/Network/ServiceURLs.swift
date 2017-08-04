//
//  ServiceURLs.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation

class ServiceURLs {
    static let shared = ServiceURLs()
    
    let pizzasUrl: String
    
    fileprivate init() {
        if let baseURL = Bundle.main.infoDictionary?["baseURL"] {
            pizzasUrl = "\(baseURL)/pizzas"
        } else {
            fatalError("baseURL must be specified in Info.plist")
        }
    }
}
