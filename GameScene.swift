//
//  GameScene.swift
//  MyFirstSpriteKitGame
//
//  Created by Alper on 27/02/16.
//  Copyright (c) 2016 allperr. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Player 1 : Creating player As Sprite
    let player = SKSpriteNode(imageNamed : "player")
    
    override func didMoveToView(view: SKView) {
        //Background Color of Scene
        backgroundColor = SKColor.whiteColor()
        
        // Horizontally :Center , Vertically : %10
        player.position = CGPoint(x: size.width * 0.1 , y: size.height * 0.5)
        
        // Add sprite as child of the scene
        addChild(player)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
