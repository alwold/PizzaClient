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

class PizzaListViewController: UITableViewController, ErrorHandling {
    var pizzas = [Pizza]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl?.beginRefreshing()
        loadPizzas()
    }
    
    @IBAction func refreshRequested(_ sender: UIRefreshControl) {
        loadPizzas()
    }
    
    fileprivate func loadPizzas() {
        WebServiceClient.shared.getPizzas(
            success: { pizzas in
                self.refreshControl?.endRefreshing()
                self.pizzas = pizzas
                self.tableView.reloadData()
            },
            failure: { error in
                self.refreshControl?.endRefreshing()
                self.showError(error.localizedDescription)
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
