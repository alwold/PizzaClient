//
//  WebServiceClient.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import Alamofire

enum NoJsonError: Error {
    case noJson
}

class WebServiceClient {
    static let shared = WebServiceClient()
    
    func getPizzas(success: @escaping ([Pizza]) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(ServiceURLs.shared.pizzasUrl).responseJSON { response in
            if let error = response.result.error {
                failure(error)
            } else if let json = response.result.value {
                do {
                    success(try [Pizza].decode(json))
                } catch {
                    failure(error)
                }
            } else {
                failure(NoJsonError.noJson)
            }
        }
    }
}
