//
//  HumanComputerViewController.swift
//  Farkle
//
//  Created by Steve Hudson on 6/18/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()      
    }
    
    @IBAction func backButtonPress(sender : AnyObject) {
        self.navigationController.popViewControllerAnimated(true)
    }

}
