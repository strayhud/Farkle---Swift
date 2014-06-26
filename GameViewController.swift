//
//  GameViewController.swift
//  Farkle
//
//  Created by Steve Hudson on 6/19/14.
//  Copyright (c) 2014 Steve Hudson. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  
  // A few variables we need...
  let WINNING_SCORE=10000   // End game constant - should be configurable in the UI
  var turnTotal = 0
  var dieImages = UIImage[]()
  let rollSound = Sound(filename:"DiceRoll",type:"mp3")
  let blewitSound = Sound(filename:"billy9", type:"mp3")
  
  // outlets for referencing the UI components.  die drops are the ImageViews that
  // display the actual dice.
  @IBOutlet var dieDrop1 : UIImageView
  @IBOutlet var dieDrop2 : UIImageView
  @IBOutlet var dieDrop3 : UIImageView
  @IBOutlet var dieDrop4 : UIImageView
  @IBOutlet var dieDrop5 : UIImageView
  @IBOutlet var dieDrop6 : UIImageView
  @IBOutlet var turnTotalField : UILabel
  @IBOutlet var playerScore : UILabel
  @IBOutlet var computerScore : UILabel
  @IBOutlet var rollButton : UIButton
  @IBOutlet var bankButton : UIButton
  
  // onload function for initializing a new game
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Die Images come in 3 sets:
    // 1-6 are black die that represent a normal state
    // 7-12 are green die that represent a scoring state
    // 13-18 are red die that represent a failed state i.e. "a farkle"
    dieImages = [
      UIImage(named: "die1.png"),
      UIImage(named: "die2.png"),
      UIImage(named: "die3.png"),
      UIImage(named: "die4.png"),
      UIImage(named: "die5.png"),
      UIImage(named: "die6.png"),
      UIImage(named: "die7.png"),
      UIImage(named: "die8.png"),
      UIImage(named: "die9.png"),
      UIImage(named: "die10.png"),
      UIImage(named: "die11.png"),
      UIImage(named: "die12.png"),
      UIImage(named: "die13.png"),
      UIImage(named: "die14.png"),
      UIImage(named: "die15.png"),
      UIImage(named: "die16.png"),
      UIImage(named: "die17.png"),
      UIImage(named: "die18.png")
     ]
    bankButton.enabled = false;
  }
  
  // Quit button action
  @IBAction func backButtonPress(sender : AnyObject) {
    self.navigationController.popViewControllerAnimated(true)
  }
  
  // setDieImage is a helper function for setting the image of die drop.  
  // offset determines which set of the die images to reference.  
  //  -1 for a black die, 5 for a green die, 11 for a red die
  func setDieImage(drop : UIImageView, dieIndex : Int, total : Int) {
    var offset = -1
    if !gameModel.isDieActive(dieIndex) {
      offset = total==0 ? 11 : 5
    }
    drop.image = dieImages[gameModel.getDieValue(dieIndex)+offset]
  }

  // turnTotalField is the information displyed just beneath the dice.
  func updateTurnTotalField(str:String) {
    println("\(str)")
    turnTotalField.text = str
  }
  
  // rollDice function - called from the roll button for humans and from the computerTurn
  // function for the computer
  func rollDice() -> Int {
    var t = gameModel.rollDice()
    rollSound.play()
    setDieImage(dieDrop1,dieIndex: 0, total: t)
    setDieImage(dieDrop2,dieIndex: 1, total: t)
    setDieImage(dieDrop3,dieIndex: 2, total: t)
    setDieImage(dieDrop4,dieIndex: 3, total: t)
    setDieImage(dieDrop5,dieIndex: 4, total: t)
    setDieImage(dieDrop6,dieIndex: 5, total: t)
    return t
  }
  
  // resetBoard - called between turns to reset things
  func resetBoard(msg:String) {
    rollButton.enabled = true
    bankButton.enabled = false
    turnTotal = 0;
    gameModel.resetDice()
    updateTurnTotalField(msg)
    setDieImage(dieDrop1,dieIndex: 0, total: 0)
    setDieImage(dieDrop2,dieIndex: 1, total: 0)
    setDieImage(dieDrop3,dieIndex: 2, total: 0)
    setDieImage(dieDrop4,dieIndex: 3, total: 0)
    setDieImage(dieDrop5,dieIndex: 4, total: 0)
    setDieImage(dieDrop6,dieIndex: 5, total: 0)
  }
  
  
  // Roll Button
  @IBAction func rollButtonPress(sender : AnyObject) {

    var t = rollDice()
    
    if t != 0 {
      turnTotal += t;
      updateTurnTotalField("\(turnTotal)")
      bankButton.enabled = true
    } else {
      self.resetBoard("You Farkled!")
      blewitSound.play()
      bankButton.enabled = false
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        self.computerTurn()
      })
    }

  }
  
  // Bank Button
  @IBAction func bankButtonPress(sender : AnyObject) {
    
    gameModel.getPlayer(0).score += turnTotal
    self.playerScore.text = "\(gameModel.getPlayer(0).score)"

    if (gameModel.getPlayer(0).score>=WINNING_SCORE) {
      updateTurnTotalField("You Win!")
      gameModel.getPlayer(0).score = 0
      gameModel.getPlayer(1).score = 0;
    } else {
      resetBoard("You Scored \(turnTotal)")
      computerTurn()
    }
   
  }
  
  // Computer turn logic..
  func computerTurn() {
  
    rollButton.enabled = false
    
    println("---- Computer Turn ----")
    
    var t = rollDice()
    
    // Exit on farkle...
    if t==0 {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        self.resetBoard("Computer Farkled!")
        })
      return
    }
    
    // Otherwise update total and figure out if the computer wants to continue based
    // on how many dice are left and how far away he is from the human
    turnTotal += t
    updateTurnTotalField("\(turnTotal)")
    
    var diceLeft = gameModel.countActiveDice()
    var delta = gameModel.getPlayer(0).score - gameModel.getPlayer(1).score
    var done = false
    
    switch diceLeft {
    case 1:
      done = true
    case 2:
      if (turnTotal>=300) {
        done = true
      }
    case 3:
      if (turnTotal>=400) {
        done = true
      }
      // The following can only occur after scoring all 6 dice at least once and cause the
      // computer to get cautious if he's built a big score.  Unless he's a long way behind
      // in which case he will go for it.  Comment these out for a hard computer brain and he
      // always goes for it.
    case 4:
      if (turnTotal>=600 && turnTotal>delta/2) {
        done = true
      }
    case 5:
      if (turnTotal>=800 && turnTotal>delta/2) {
        done = true
      }
    default:
      break;
    }
   
    if (done) {
      gameModel.getPlayer(1).score += turnTotal
      self.computerScore.text = "\(gameModel.getPlayer(1).score)"
      updateTurnTotalField("Computer Scored \(turnTotal)")

      if (gameModel.getPlayer(1).score>=WINNING_SCORE) {
        updateTurnTotalField("Computer Won!")
        gameModel.getPlayer(0).score = 0
        gameModel.getPlayer(1).score = 0;
      }
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
        self.resetBoard(" ")
        })
    } else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
          self.computerTurn()
      })
    }
  }
  
}


