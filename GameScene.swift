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
    
    //NOTE: The normalized vector of CGPoint vector is a vector in the same direction but with norm (length) 1.
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //1 - Choose the touch to work with
        
        guard let touch = touches.first else{
            
            return /* return will end the func immediately , no further code inside this method will be executed*/
        }
        let touchLocation = touch.locationInNode(self)
        
        //2 - Set up initial location of projectile(the power that ninja thrown )
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
    
        //3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        //4 - you cant shoot backward
        if (offset.x)<0 { return }
        
        //5 - Already checked the position so add projectile
        addChild(projectile)
        
        //6 - Get the direction of where you shoot 
        let direction = offset.normalized()
        
        //7 - Make it shoot far enough to be guaranteed off screen 
            //It will definitely be long enough to go past the edge of the screen
        let shootAmount = direction * 1000
        
        //8 - Add the shoot amount to the current position 
        let realDest = shootAmount + projectile.position
        
        //9 - Create the actions 
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.runAction(SKAction.sequence([actionMove,actionMoveDone]))
    
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
