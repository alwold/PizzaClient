//
//  PizzaViewController.swift
//  PizzaClient
//
//  Created by Al Wold on 8/5/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import Foundation
import UIKit

class PizzaViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toppingsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor(white: 0.94, alpha: 1.0).cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // resize the table to fit content
        self.toppingsTableView.frame = CGRect(x: self.toppingsTableView.frame.origin.x, y: self.toppingsTableView.frame.origin.y, width: self.toppingsTableView.bounds.size.width, height: self.toppingsTableView.contentSize.height)
        
        // resize the scroll view content to fit the new table size
        let tableViewBottomY = self.toppingsTableView.frame.origin.y + self.toppingsTableView.frame.size.height
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: tableViewBottomY + 10)
    }
}
