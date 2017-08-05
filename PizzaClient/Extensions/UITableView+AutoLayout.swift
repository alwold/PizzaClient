//
//  UITableView+AutoLayout.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit

extension UITableView {
    func enableAutoLayout() {
        self.estimatedRowHeight = 80
        self.rowHeight = UITableViewAutomaticDimension
    }
}
