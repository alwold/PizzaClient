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

protocol PizzaDelegate: class {
    func pizzaUpdated(pizza: Pizza)
}

class PizzaViewController : UIViewController, UITableViewDataSource, ErrorHandling, AddPizzaToppingsDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var toppingsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toppingsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noToppingsLabel: UILabel!
    
    var pizza: Pizza?
    var toppings = [PizzaTopping]()
    var availableToppings: [Topping]?
    var toppingsToAdd = [Topping]()
    var hideNoToppingsLabelConstraint: NSLayoutConstraint?
    weak var delegate: PizzaDelegate?
    
    var allToppings: [DisplayableTopping] {
        get {
            return toppings as [DisplayableTopping] + toppingsToAdd as [DisplayableTopping]
        }
    }
    
    var hideNoToppingsLabel: Bool {
        get {
            return hideNoToppingsLabelConstraint?.isActive == true
        }
        set (hidden) {
            if hidden {
                if hideNoToppingsLabelConstraint == nil {
                    hideNoToppingsLabelConstraint = noToppingsLabel.heightAnchor.constraint(equalToConstant: 0)
                }
                hideNoToppingsLabelConstraint?.isActive = true
            } else {
                hideNoToppingsLabelConstraint?.isActive = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderColor = UIColor(white: 0.94, alpha: 1.0).cgColor
        toppingsTableView.enableAutoLayout()
        
        if !toppings.isEmpty {
            hideNoToppingsLabel = true
        }
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
                // remove any toppings already on the pizza from the available to add list
                self.availableToppings = toppings.filter { topping in
                    return !self.hasTopping(id: topping.id)
                }
                self.performSegue(withIdentifier: "addToppingSegue", sender: sender)
            },
            failure: { error in
                hud.hide(animated: true)
                self.showError(error.localizedDescription)
            }
        )
    }
    
    func hasTopping(id: Int) -> Bool {
        for existingTopping in self.toppings {
            if  id == existingTopping.toppingId {
                return true
            }
        }
        for existingTopping in self.toppingsToAdd {
            if id == existingTopping.id {
                return true
            }
        }
        return false
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
        hideNoToppingsLabel = true
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
                    let newError = "\(topping.name): \(error.localizedDescription)"
                    self.addNextTopping(pizza: pizza, hud: hud, errors: errors + [newError])
                }
            )
        } else {
            hud.hide(animated: true)
            if errors.isEmpty {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.pizzaUpdated(pizza: pizza)
            } else {
                let alert = UIAlertController(title: "Couldn't add toppings", message: errors.joined(separator: "\n"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.pizzaUpdated(pizza: pizza)
                }))
                present(alert, animated: true)
            }
        }
    }
}
