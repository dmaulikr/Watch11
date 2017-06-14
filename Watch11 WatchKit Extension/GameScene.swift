//
//  GameScene.swift
//  Watch11
//
//  Created by Macbook on 14/06/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import SpriteKit

class GameScene: SKScene, WKCrownDelegate {

     var gameScene: GameScene!
     var player = SKNode()
     var leftEdge = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10, height: 174))
     var rightEdge = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10, height: 172))
     var topEdge = SKSpriteNode(color: UIColor.white, size: CGSize(width: 154, height: 10))
     var bottomEdge = SKSpriteNode(color: UIColor.white, size: CGSize(width: 154, height: 10))
     var isPlayerAlive = true
     let colorNames = ["Red", "Blue", "Green", "Yellow"]
     let colorValues: [UIColor] = [.red, .blue, .green, .yellow]
     var alertDelay = 1.0
     var moveSpeed = 70.0
     var createDelay = 0.5
     
     
     

     override func sceneDidLoad() {
          
          backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
          
          let red = createPlayer(color: "Red")
          red.position = CGPoint(x: -8, y: 8)
          
          let blue = createPlayer(color: "Blue")
          blue.position = CGPoint(x: 8, y: 8)
          
          let green = createPlayer(color: "Green")
          green.position = CGPoint(x: -8, y: -8)
          
          let yellow = createPlayer(color: "Yellow")
          yellow.position = CGPoint(x: 8, y: -8)
          
          addChild(player)
          
          leftEdge.position = CGPoint(x: -77, y: 0)
          rightEdge.position = CGPoint(x: 77, y: 0)
          topEdge.position = CGPoint(x: 0, y: 87)
          bottomEdge.position = CGPoint(x: 0, y: -87)
          
          for edge in [leftEdge, rightEdge, topEdge, bottomEdge] {
               
                edge.colorBlendFactor = 1
                edge.alpha = 0
                addChild(edge)
          }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + createDelay) {
               self.launchBall()
          }
          
     }
     
     func createPlayer(color: String) -> SKSpriteNode {
     
          let component = SKSpriteNode(imageNamed: "player\(color)")
          
          component.name = color
          player.addChild(component)
          
          return component
     
     }
     
     func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
          
          player.zRotation -= CGFloat(rotationalDelta) * 20
     }
     
     func pickEdge() -> (position: CGPoint, force: CGVector, edge: SKSpriteNode) {
          
          let direction = arc4random_uniform(4)
          
          switch direction {
               
          case 0:
               return (CGPoint(x: -90, y: 0), CGVector(dx: moveSpeed, dy: 0), leftEdge)
               
          case 1:
               return (CGPoint(x: 90, y: 0), CGVector(dx: -moveSpeed, dy: 0), rightEdge)
               
          case 2:
               return (CGPoint(x: 0, y: -100), CGVector(dx: 0, dy: moveSpeed), bottomEdge)
               
          default:
               return (CGPoint(x: 0, y: 100), CGVector(dx: 0, dy: -moveSpeed), topEdge)
               
          }
      }
     
     func createBall(color: String) -> SKSpriteNode {
          
          let ball = SKSpriteNode(imageNamed: "ball\(color)")
          ball.name = color
          ball.physicsBody = SKPhysicsBody(circleOfRadius: 12)
          ball.physicsBody!.linearDamping = 0
          ball.physicsBody!.affectedByGravity = false
          ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
          
          addChild(ball)
          
          return ball
     }
     
     func launchBall() {
          
          //ball out if the game is over
          guard isPlayerAlive else { return }
          
          //pick a random ball color
          let ballType = Int(arc4random_uniform(UInt32(colorNames.count)))
          
          //create a ball from that random color
          let ball = createBall(color: colorNames[ballType])
          
          //get a random edge to launch from, plus position and force to apply
          let (position, force, edge) = pickEdge()
          
          //place the ball at its starting location
          ball.position = position
          
          let flashEdge = SKAction.run {
               
               edge.color = self.colorValues[ballType]
               edge.alpha = 1
          }
          
          let resetEdge = SKAction.run {
               
               edge.alpha = 0
          }
          
          let launchBall = SKAction.run {
               
               ball.physicsBody!.velocity = force
          }
          
          let sequence = SKAction.sequence([flashEdge, SKAction.wait(forDuration: alertDelay), resetEdge, launchBall])
          
          run(sequence)
          alertDelay *= 0.98
  
     }

}
