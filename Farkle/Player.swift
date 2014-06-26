//
//  Player.swift
//  Farkle
//
//  Created by Steve Hudson on 6/21/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import Foundation

class Player {
  var name:String
  var score:Int
  
  init(name:String) {
    self.name = name
    self.score = 0
  }
  
  func print() {
    println("\(name), score=\(score)")
  }
}
