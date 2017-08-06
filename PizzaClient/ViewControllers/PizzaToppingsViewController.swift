//
//  PizzaToppingsViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit

protocol AddPizzaToppingsDelegate: class {
    func add(toppings: [Topping])
}

class PizzaToppingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var availableToppings: [Topping]!
    var selectedRows = [Int]()
    weak var delegate: AddPizzaToppingsDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedToppings: [Topping] {
        var toppings = [Topping]()
        for selectedRow in selectedRows {
            toppings.append(availableToppings[selectedRow])
        }
        return toppings
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableToppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath)
        cell.textLabel?.text = availableToppings[indexPath.row].name
        if selectedRows.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedRows.index(of: indexPath.row) {
            selectedRows.remove(at: index)
        } else {
            selectedRows.append(indexPath.row)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.add(toppings: self.selectedToppings)
        }
    }
}
