//
//  GameScene.swift
//  MyFirstSpriteKitGame
//
//  Created by Alper on 27/02/16.
//  Copyright (c) 2016 allperr. All rights reserved.
//

import SpriteKit

//MARK: - Global Fuctions
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

func random() -> CGFloat{
    return CGFloat (Float(arc4random())/0xFFFFFFFF)
}

func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
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

//MARK: - Constants

struct PhysicsCategory {
    static let None       : UInt32  = 0
    static let All        : UInt32  = UInt32.max
    static let Monster    : UInt32  = 0b1    //1
    static let Projectile : UInt32  = 0b10   //2
    
}

//MARK: - GameScene Class
class GameScene: SKScene ,SKPhysicsContactDelegate{
    
        // Decleration of player (ninja)
        let player = SKSpriteNode(imageNamed : "player")
    
    
    var monsterDestroyed : Int = 0

    //MARK: AddMonster to Scene
        func addMonster(){
        
        //Create Monster Sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
            //MARK: Physics Body Of Monster
            //the body is defined as a rectangle of same size of the sprite
            monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        
            monster.physicsBody?.dynamic = true
        
            monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        
            //Get notified when projectile and monster intersect.
            monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        
            //You don’t want the monster and projectile to bounce off each other , so no collision
            monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //Where the monster spawn along the Y axis
            let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        //Put monster slightly of screen along the right edge
            monster.position = CGPoint(x: size.width + monster.size.width / 2 , y: actualY)
        
        //Add the monster to the scene
            addChild(monster)
        
        //Determine the speed of the monster
            let actualDuration = random(min: CGFloat(1.5), max: CGFloat(5.0))
        
        //Create the actions
            let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        
            let actionMoveDone = SKAction.removeFromParent()
            
        //Display the "GameOverScene" when a monster goes off screen
            let loseAction = SKAction.runBlock(){
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                
                self.view?.presentScene(gameOverScene, transition: reveal)
            
            }
        
        /*Important!
            Q.Why is Lose Action First?
            As soon as you remove a sprite from its parent, it is no longer in the scene hierarchy so no more actions will take place from that point on. So you don’t want to remove the sprite from the scene until you’ve transitioned to the lose scene.
            
            */
        monster.runAction(SKAction.sequence([actionMove,actionMoveDone,loseAction]))
        
            
        
    }
    
    //Remove the projectile and monster from the scenery after collide
    func projectileDidCollideWithMonster(projectile projectile : SKSpriteNode, monster : SKSpriteNode){
        print ("Hit")
        monster.removeFromParent()
        projectile.removeFromParent()
        
        
        monsterDestroyed++
        
        if monsterDestroyed > 15 {
            
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
            
        }
        
        
    }
    
    
    //MARK: Override Methods
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //1 - Choose the touch to work with
        guard let touch = touches.first else{
            
            return /* return will end the func immediately , no further code inside this method will be executed*/
        }
        let touchLocation = touch.locationInNode(self)
        
        //2 - Set up initial location of projectile(the power that ninja thrown )
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
            //MARK:Physics Body Of Projectile
                //Circle shape of Body
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
                projectile.physicsBody?.dynamic = true
                projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
                projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
                projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            
                projectile.physicsBody?.usesPreciseCollisionDetection = true
                /*You also set usesPreciseCollisionDetection to true. This is important to set for fast moving bodies (like projectiles), because otherwise there is a chance that two fast moving bodies can pass through each other without a collision being detected.*/
    
        //3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        //4 - you cant shoot backward
        //if (offset.x)<0 { return }
        
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
        
            runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    }

    override func didMoveToView(view: SKView) {
        //Background Color of Scene
            backgroundColor = SKColor.whiteColor()
        
        //Adding Player to the Scene
            // Horizontally :Center , Vertically : %10
            player.position = CGPoint(x: size.width * 0.1 , y: size.height * 0.5)
            
            // Add sprite as child of the scene
            addChild(player)
        
        //Physics World
            // No gravity
            physicsWorld.gravity = CGVectorMake(0,0)
        
            //When the physics collide , sets the scene as delegate to be notified
            physicsWorld.contactDelegate = self
        
        //Adding Monster to the Scene
            runAction(
                SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(1.0)]))
            )
        
//        //MonsterKillerCounter
//        let counter = SKLabelNode(fontNamed: "Chalkduster")
//        counter.text = ("Killed: \(monsterDestroyed)")
//        counter.fontSize = 10
//        counter.fontColor = SKColor.blackColor()
//        counter.position = (CGPoint(x: size.width*0.9, y: size.height*0.1))
//        addChild(counter)
        
        //Background Music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
    }// end of DidMoveTo func
    
    
    //MARK: SKPhysicsContactDelegate Methods
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Arrangment of bodies: firstBody is small, secondBody is big
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        /*Reminder: &(bitwise) operator - always evaluate both expressions
                   &&(logical) operator - evaluates the second expression only if the first expression is true.(More Efficient)*/
        
        if (firstBody.categoryBitMask & PhysicsCategory.Monster != 0 ) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0){
            
            projectileDidCollideWithMonster(projectile: firstBody.node as! SKSpriteNode , monster: secondBody.node as! SKSpriteNode)
        }
    }

    
}
