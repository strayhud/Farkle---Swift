//
//  FarkleMainViewController.swift
//  Farkle
//
//  Created by Steve Hudson on 6/18/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import UIKit

let gameModel = GameModel()

class FarkleMainViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModel.addPlayer(Player(name: "You"))
        gameModel.addPlayer(Player(name: "Computer"))
    }

}

