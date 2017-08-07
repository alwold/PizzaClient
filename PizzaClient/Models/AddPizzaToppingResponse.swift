//
//  AddPizzaToppingResponse.swift
//  PizzaClient
//
//  Created by Al Wold on 8/6/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import Decodable

// sample success response:
//{
//    "object": {
//        "id": 6,
//        "pizza_id": 1,
//        "topping_id": 5
//    },
//    "errors": {}
//}

// sample error response:
//{
//    "object": {
//        "id": null,
//        "pizza_id": 1,
//        "topping_id": 5
//    },
//    "errors": {
//        "pizza_topping": [
//        "This pizza topping already exists"
//        ]
//    }
//}

struct AddPizzaToppingResponse : Decodable {
    let object: PizzaToppingInfo
    let errors: [String: [String]]
    
    static func decode(_ json: Any) throws -> AddPizzaToppingResponse {
        return try self.init(
            object: json => "object",
            errors: json => "errors"
        )
    }
}

struct PizzaToppingInfo : Decodable {
    let id: Int?
    let pizzaId: Int
    let toppingId: Int
    
    static func decode(_ json: Any) throws -> PizzaToppingInfo {
        return try self.init(
            id: json =>? "id",
            pizzaId: json => "pizza_id",
            toppingId: json => "topping_id"
        )
    }
}
