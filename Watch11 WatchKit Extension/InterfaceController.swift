//
//  InterfaceController.swift
//  Watch11 WatchKit Extension
//
//  Created by Macbook on 14/06/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit


class InterfaceController: WKInterfaceController {

     @IBOutlet var gameInterface: WKInterfaceSKScene!
     
     var gameScene: GameScene!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startGame(self)
     
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

     @IBAction func startGame(_ sender: Any) {
     
          if gameScene != nil {
               guard gameScene.isPlayerAlive == false else { return }
          }
          
          gameScene = GameScene(size: CGSize(width: 154, height: 174))
          
          gameScene.parentInterfaceController = self
          gameScene.score = 0
          gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
          
          crownSequencer.focus()
          crownSequencer.delegate = gameScene
          
          let transition = SKTransition.doorway(withDuration: 1)
          gameInterface.presentScene(gameScene, transition: transition)
          
          
     }
}
