//
//  Pizza.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import Decodable

struct Pizza: Decodable {
    let id: Int
    let name: String
    let description: String
    
    static func decode(_ json: Any) throws -> Pizza {
        return try self.init(
            id: json => "id",
            name: json => "name",
            description: json => "description"
        )
    }
}
