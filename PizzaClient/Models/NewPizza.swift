//
//  NewPizza.swift
//  PizzaClient
//
//  Created by Al Wold on 8/6/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation

struct NewPizza {
    let name: String
    let description: String
    
    func encode() -> [String: [String: String]] {
        return [
            "pizza": [
                "name": name,
                "description": description
            ]
        ]
    }
}
