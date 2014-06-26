//
//  RulesViewController.swift
//  Farkle
//
//  Created by Steve Hudson on 6/24/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func backButton(sender : AnyObject) {
    self.navigationController.popViewControllerAnimated(true)
  }
}
