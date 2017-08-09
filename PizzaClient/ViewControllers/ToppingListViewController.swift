//
//  ToppingListViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath)
        cell.textLabel?.text = toppings[indexPath.row].name
        return cell
    }

    
    // MARK: - IBActions
    @IBAction func refreshRequested(_ sender: Any) {
        loadToppings()
    }

    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Topping", message: "Please enter a name for the new topping:", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let hud = MBProgressHUD.showAdded(to: self.tabBarController!.view, animated: true)
            hud.label.text = "Adding topping"
            if let name = alert.textFields?.first?.text {
                WebServiceClient.shared.addTopping(
                    toppingName: name,
                    success: { topping in
                        hud.hide(animated: true)
                        self.toppings.append(topping)
                        self.tableView.reloadData()
                    },
                    failure: { error in
                        hud.hide(animated: true)
                        self.showError(error.localizedDescription)
                    }
                )
            } else {
                self.showError("Please enter a name for the topping.")
            }
        }))
        present(alert, animated: true)
    }
}
