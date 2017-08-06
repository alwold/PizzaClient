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
    let toppingsUrl: String
    let pizzaToppingsUrl: String
    
    fileprivate init() {
        if let baseURL = Bundle.main.infoDictionary?["baseURL"] {
            pizzasUrl = "\(baseURL)/pizzas"
            toppingsUrl = "\(baseURL)/toppings"
            pizzaToppingsUrl = "\(pizzasUrl)/%d/toppings"
        } else {
            fatalError("baseURL must be specified in Info.plist")
        }
    }
}
