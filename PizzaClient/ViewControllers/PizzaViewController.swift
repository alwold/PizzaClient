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
    @IBOutlet weak var toppingsTableViewHeightConstraint: NSLayoutConstraint!
    
    var pizza: Pizza?
    var toppings = [PizzaTopping]()
    var availableToppings: [Topping]?
    var toppingsToAdd = [Topping]()
    
    var allToppings: [DisplayableTopping] {
        get {
            return toppings as [DisplayableTopping] + toppingsToAdd as [DisplayableTopping]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderColor = UIColor(white: 0.94, alpha: 1.0).cgColor
        toppingsTableView.enableAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pizza = pizza {
            self.nameTextField.text = pizza.name
            self.descriptionTextView.text = pizza.description
        } else {
            self.navigationItem.title = "Add Pizza"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toppingsTableViewHeightConstraint.constant = self.toppingsTableView.contentSize.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath) as? PizzaToppingTableViewCell else {
            fatalError("Internal error: incorrect class on topping table view cell")
        }
        cell.label.text = allToppings[indexPath.row].name
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
            toppingsToAdd.append(newTopping)
        }
        toppingsTableView.reloadData()
        // adjust the layout to accomodate the new table view size
        view.setNeedsLayout()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let name = nameTextField.text, let description = descriptionTextView.text, !name.isEmpty, !description.isEmpty {
            let hud = MBProgressHUD.showAdded(to: self.tabBarController!.view, animated: true)
            if let pizza = pizza {
                addNextTopping(pizza: pizza, hud: hud, errors: [])
            } else {
                WebServiceClient.shared.addPizza(
                    pizza: NewPizza(name: name, description: description),
                    success: { pizza in
                        self.addNextTopping(pizza: pizza, hud: hud, errors: [])
                    },
                    failure: { error in
                        self.showError(error.localizedDescription)
                    }
                )
            }
        } else {
            showError("Please enter a name and description for the pizza")
        }
    }
    
    fileprivate func addNextTopping(pizza: Pizza, hud: MBProgressHUD, errors: [String]) {
        if let topping = toppingsToAdd.popLast() {
            let pizzaTopping = PizzaTopping(id: nil, pizzaId: pizza.id, toppingId: topping.id, name: topping.name)
            WebServiceClient.shared.addToppingToPizza(
                topping: pizzaTopping,
                success: { response in
                    self.addNextTopping(pizza: pizza, hud: hud, errors: errors)
                },
                failure: { error in
                    self.addNextTopping(pizza: pizza, hud: hud, errors: errors + [error.localizedDescription])
                }
            )
        } else {
            hud.hide(animated: true)
            if errors.isEmpty {
                self.navigationController?.popViewController(animated: true)
                // TODO notify a delegate if pizza is added
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
