//
//  ToppingListViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit

class ToppingListViewController : UITableViewController, ErrorHandling {
    var toppings = [Topping]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.beginRefreshing()
        loadToppings()
    }
    
    func loadToppings()  {
        WebServiceClient.shared.getToppings(
            success: { toppings in
                self.refreshControl?.endRefreshing()
                self.toppings = toppings
                self.tableView.reloadData()
            },
            failure: { error in
                self.refreshControl?.endRefreshing()
                self.showError(error.localizedDescription)
            }
        )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath)
        cell.textLabel?.text = toppings[indexPath.row].name
        return cell
    }
}
