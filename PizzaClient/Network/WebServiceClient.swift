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

struct AddToppingError: Error, LocalizedError {
    let errorDescription: String?
    
    init(errors: [String: [String]]) {
        var allErrors = [String]()
        for error in errors {
            allErrors.append(contentsOf: error.value)
        }
        self.errorDescription = allErrors.joined(separator: "\n")
    }
}

class WebServiceClient {
    static let shared = WebServiceClient()
    
    func getPizzas(success: @escaping ([Pizza]) -> Void, failure: @escaping (Error) -> Void) {
        getJSON(
            from: ServiceURLs.shared.pizzasUrl,
            success: { json in
                do {
                    try success([Pizza].decode(json))
                } catch {
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    func getToppings(success: @escaping ([Topping]) -> Void, failure: @escaping (Error) -> Void) {
        getJSON(
            from: ServiceURLs.shared.toppingsUrl,
            success: { json in
                do {
                    try success([Topping].decode(json))
                } catch {
                    failure(error)
                }
        },
            failure: failure
        )
    }
    
    func getPizzaToppings(pizzaId: Int, success: @escaping ([PizzaTopping]) -> Void, failure: @escaping (Error) -> Void) {
        getJSON(
            from: String(format: ServiceURLs.shared.pizzaToppingsUrl, pizzaId),
            success: { json in
                do {
                    try success([PizzaTopping].decode(json))
                } catch {
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    func addTopping(toppingName: String, success: @escaping (Topping) -> Void, failure: @escaping (Error) -> Void) {
        let parameters = [
            "topping": [
                "name": toppingName
            ]
        ]
        Alamofire.request(
            ServiceURLs.shared.toppingsUrl,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: nil)
            .responseJSON { response in
                if let error = response.result.error {
                    failure(error)
                } else if let json = response.result.value {
                    do {
                        try success(Topping.decode(json))
                    } catch {
                        failure(error)
                    }
                } else {
                    failure(NoJsonError.noJson)
                }

        }
        
    }
    
    func addToppingToPizza(topping: PizzaTopping, success: @escaping (AddPizzaToppingResponse) -> Void, failure: @escaping (Error) -> Void) {
        let parameters = [
            "topping_id": topping.toppingId
        ]
        Alamofire.request(
            String(format: ServiceURLs.shared.pizzaToppingsUrl, topping.pizzaId),
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: nil)
            .responseJSON { response in
                if let error = response.result.error {
                    failure(error)
                } else if let json = response.result.value {
                    do {
                        let response = try AddPizzaToppingResponse.decode(json)
                        if response.errors.isEmpty {
                            success(response)
                        } else {
                            failure(AddToppingError(errors: response.errors))
                        }
                    } catch {
                        failure(error)
                    }
                } else {
                    failure(NoJsonError.noJson)
                }
                
                
        }
    }
    
    func addPizza(pizza: NewPizza, success: @escaping (Pizza) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(
            ServiceURLs.shared.pizzasUrl,
            method: .post,
            parameters: pizza.encode(),
            encoding: JSONEncoding.default,
            headers: nil
            ).responseJSON { response in
                if let error = response.result.error {
                    failure(error)
                } else if let json = response.result.value {
                    do {
                        success(try Pizza.decode(json))
                    } catch {
                        failure(error)
                    }
                } else {
                    failure(NoJsonError.noJson)
                }
        }
    }

    fileprivate func getJSON(from url: String, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                failure(error)
            } else if let json = response.result.value {
                success(json)
            } else {
                failure(NoJsonError.noJson)
            }
        }
    }
    
}
