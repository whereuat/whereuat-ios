//
//  PendingRequestsViewController.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

class PendingRequestsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItems("Pending Requests")
    }
    
}