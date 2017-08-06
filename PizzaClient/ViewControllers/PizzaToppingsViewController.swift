//
//  PizzaToppingsViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit

class PizzaToppingsViewController: UITableViewController {
    var availableToppings: [Topping]!
    var selectedRows = [Int]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableToppings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath)
        cell.textLabel?.text = availableToppings[indexPath.row].name
        if selectedRows.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedRows.index(of: indexPath.row) {
            selectedRows.remove(at: index)
        } else {
            selectedRows.append(indexPath.row)
        }
        self.tableView.reloadData()
    }
    
}
