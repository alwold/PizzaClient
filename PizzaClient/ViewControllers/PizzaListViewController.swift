//
//  PizzaListViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class PizzaListViewController: UITableViewController {
    var pizzas = [Pizza]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPizzas()
    }
    
    fileprivate func loadPizzas() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: false)
        WebServiceClient.shared.getPizzas(
            success: { pizzas in
                hud.hide(animated: false)
                self.pizzas = pizzas
                self.tableView.reloadData()
            },
            failure: { error in
                hud.hide(animated: false)
            }
        )
    }
}

extension PizzaListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pizzaCell", for: indexPath)
        
        let pizza = pizzas[indexPath.row]
        cell.textLabel?.text = pizza.name
        cell.detailTextLabel?.text = pizza.description
        
        return cell
    }
}
