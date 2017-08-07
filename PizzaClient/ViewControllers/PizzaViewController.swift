//
//  PizzaViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class PizzaViewController : UIViewController, UITableViewDataSource, ErrorHandling, AddPizzaToppingsDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var toppingsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pizza: Pizza!
    var toppings: [PizzaTopping]!
    var availableToppings: [Topping]?
    var toppingsToAdd = [PizzaTopping]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderColor = UIColor(white: 0.94, alpha: 1.0).cgColor
        toppingsTableView.enableAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameTextField.text = pizza.name
        self.descriptionTextView.text = pizza.description
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // resize the table to fit content
        self.toppingsTableView.frame = CGRect(x: self.toppingsTableView.frame.origin.x, y: self.toppingsTableView.frame.origin.y, width: self.toppingsTableView.bounds.size.width, height: self.toppingsTableView.contentSize.height)
        
        // resize the scroll view content to fit the new table size
        let tableViewBottomY = self.toppingsTableView.frame.origin.y + self.toppingsTableView.frame.size.height
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: tableViewBottomY + 10)
        // TODO add enough space for the add button
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath) as? PizzaToppingTableViewCell else {
            fatalError("Internal error: incorrect class on topping table view cell")
        }
        cell.label.text = toppings[indexPath.row].name
        cell.toppingId = 1
        return cell
    }
    
    @IBAction func addToppingTapped(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.tabBarController!.view, animated: true)
        WebServiceClient.shared.getToppings(
            success: { toppings in
                hud.hide(animated: true)
                // TODO remove existing from list
                self.availableToppings = toppings
                self.performSegue(withIdentifier: "addToppingSegue", sender: sender)
            },
            failure: { error in
                hud.hide(animated: true)
                self.showError(error.localizedDescription)
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pizzaToppingsViewController = segue.destination as? PizzaToppingsViewController {
            pizzaToppingsViewController.availableToppings = availableToppings
            pizzaToppingsViewController.delegate = self
        }
    }
    
    func add(toppings newToppings: [Topping]) {
        for newTopping in newToppings {
            let newPizzaTopping = PizzaTopping(id: nil, pizzaId: pizza.id, toppingId: newTopping.id, name: newTopping.name)
            toppings.append(newPizzaTopping)
            toppingsToAdd.append(newPizzaTopping)
        }
        toppingsTableView.reloadData()
        // adjust the layout to accomodate the new table view size
        view.setNeedsLayout()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.tabBarController!.view, animated: true)
        addNextTopping(hud: hud, errors: [])
    }
    
    fileprivate func addNextTopping(hud: MBProgressHUD, errors: [String]) {
        if let topping = toppingsToAdd.popLast() {
            WebServiceClient.shared.addToppingToPizza(
                topping: topping,
                success: { response in
                    self.addNextTopping(hud: hud, errors: errors)
                },
                failure: { error in
                    self.addNextTopping(hud: hud, errors: errors + [error.localizedDescription])
                }
            )
        } else {
            hud.hide(animated: true)
            if errors.isEmpty {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Errors adding toppings", message: errors.joined(separator: "\n"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)

                }))
                present(alert, animated: true)
            }
        }
    }
}
