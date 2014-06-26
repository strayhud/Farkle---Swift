//
//  File.swift
//  Farkle
//
//  Created by Steve Hudson on 6/24/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
  
  var sound:NSURL
  var player:AVAudioPlayer
  
  init(filename:String, type:String) {
    sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: type))
    player = AVAudioPlayer(contentsOfURL: sound, error: nil)
    player.prepareToPlay()
  }
  
  func play() {
    player.play()
  }
  
}
