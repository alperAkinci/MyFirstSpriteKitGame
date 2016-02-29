//
//  GameScene.swift
//  MyFirstSpriteKitGame
//
//  Created by Alper on 27/02/16.
//  Copyright (c) 2016 allperr. All rights reserved.
//

import SpriteKit

//MARK: - Math Operator Fuctions
func + (left: CGPoint , right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x + right.x , y : right.y + left.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point : CGPoint , scalar : CGFloat) -> CGPoint {
    return CGPoint (x: point.x * scalar , y: point.y * scalar)
}

func / (point : CGPoint , scalar : CGFloat) -> CGPoint {
    return CGPoint (x : point.x / scalar , y : point.y / scalar)
}


func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}


//MARK: - CGPoint Extensions

extension CGPoint{
    func length() -> CGFloat {
        return sqrt((x*x) + (y*y))
    }
    
    
    func normalized() -> CGPoint {
        //Operator Overloading in Swift (/)
        return self / length()
    }
}



//MARK: - GameScene Class
class GameScene: SKScene {
    
    
    
    
    // Player 1 : Creating player As Sprite
    let player = SKSpriteNode(imageNamed : "player")
    
    //MARK: - Random Fuctions
    func random() -> CGFloat{
        return CGFloat (Float(arc4random())/0xFFFFFFFF)
    }
    
    func randomMinMax(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster(){
        
        //Create Monster Sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        //Where the monster spawn along the Y axis
        let actualY = randomMinMax(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        //Put monster slightly of screen along the right edge
        monster.position = CGPoint(x: size.width + monster.size.width / 2 , y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine the speed of the monster
        let actualDuration = randomMinMax(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        
    }
    
   

    
    override func didMoveToView(view: SKView) {
        //Background Color of Scene
        backgroundColor = SKColor.whiteColor()
        
        // Horizontally :Center , Vertically : %10
        player.position = CGPoint(x: size.width * 0.1 , y: size.height * 0.5)
        
        // Add sprite as child of the scene
        addChild(player)
        
        runAction(
            SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(1.0)]))
        )
        
        
    }

    
}
