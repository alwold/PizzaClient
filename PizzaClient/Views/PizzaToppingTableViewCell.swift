//
//  PizzaToppingTableViewCell.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import UIKit

class PizzaToppingTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    var toppingId: Int!
    
    @IBAction func removeTapped(_ sender: Any) {
        // TODO call delegate
    }
}
