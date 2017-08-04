//
//  Topping.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import Decodable

struct Topping: Decodable {
    let id: Int
    let name: String
    
    static func decode(_ json: Any) throws -> Topping {
        return try self.init(
            id: json => "id",
            name: json => "name"
        )
    }
}
