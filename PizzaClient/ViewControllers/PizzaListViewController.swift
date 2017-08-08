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

class PizzaListViewController: UITableViewController, ErrorHandling, PizzaDelegate {
    var pizzas = [Pizza]()
    var selectedPizza: Pizza?
    var selectedPizzaToppings: [PizzaTopping]?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pizzaViewController = segue.destination as? PizzaViewController {
            pizzaViewController.delegate = self

            if segue.identifier == "pizzaSelected" {
                pizzaViewController.pizza = selectedPizza
                // TODO check force unwrap
                pizzaViewController.toppings = selectedPizzaToppings!
            }
        }

    }
    
    func pizzaUpdated(pizza updatedPizza: Pizza) {
        for pizza in pizzas {
            if pizza.id == updatedPizza.id {
                return
            }
        }
        pizzas.append(updatedPizza)
        self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPizza = pizzas[indexPath.row]
        WebServiceClient.shared.getPizzaToppings(
            pizzaId: selectedPizza!.id,
            success: { toppings in
                self.selectedPizzaToppings = toppings
                self.performSegue(withIdentifier: "pizzaSelected", sender: nil)
            },
            failure: { error in
                self.showError(error.localizedDescription)
            }
        )
    }
}
