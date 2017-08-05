//
//  PizzaViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import UIKit

class PizzaViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toppingsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor(white: 0.94, alpha: 1.0).cgColor
        toppingsTableView.enableAutoLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // resize the table to fit content
        self.toppingsTableView.frame = CGRect(x: self.toppingsTableView.frame.origin.x, y: self.toppingsTableView.frame.origin.y, width: self.toppingsTableView.bounds.size.width, height: self.toppingsTableView.contentSize.height)
        
        // resize the scroll view content to fit the new table size
        let tableViewBottomY = self.toppingsTableView.frame.origin.y + self.toppingsTableView.frame.size.height
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: tableViewBottomY + 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toppingCell", for: indexPath) as? PizzaToppingTableViewCell else {
            fatalError("Internal error: incorrect class on topping table view cell")
        }
        cell.label.text = "Pepperoni"
        cell.toppingId = 1
        return cell
    }
    
    func removeTapped() {
        NSLog("remove")
    }
}
