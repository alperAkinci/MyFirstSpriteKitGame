//
//  GameOverScene.swift
//  MyFirstSpriteKitGame
//
//  Created by Alper on 29/02/16.
//  Copyright © 2016 allperr. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {

    init(size: CGSize , won : Bool) {
        super.init(size: size)
        
        //Set the background color white
        backgroundColor = SKColor.whiteColor()
        
        //Base on won parameter , set the message either "You Won" or "You Lose"
        let message = won ? "You Won!" : "You Lose :["
        
        //Display a winning message text to the screen
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = (CGPoint(x: size.width/2, y: size.height/2))
        addChild(label)
        
        //Run a sequence of 2 actions 
        /* Waits 3 second , then it runBlock() action */
        runAction(SKAction.sequence([SKAction.waitForDuration(3.0),
            SKAction.runBlock({ () -> Void in
                //Transition to a new scene!!
                let scene = GameScene(size:size)
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                
                self.view?.presentScene(scene, transition: reveal)
            })
        ]))
        
        
        
        
        
    }
    //If you override an initializer on a scene, you must implement the required init(coder:) initializer as well.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
