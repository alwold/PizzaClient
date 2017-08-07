//
//  PizzaTopping.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import Decodable

struct PizzaTopping : Decodable {
    let id: Int?
    let pizzaId: Int
    let toppingId: Int
    let name: String
    
    static func decode(_ json: Any) throws -> PizzaTopping {
        return try self.init(
            id: json => "id",
            pizzaId: json => "pizza_id",
            toppingId: json => "topping_id",
            name: json => "name"
        )
    }
}
