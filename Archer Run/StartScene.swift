//
//  StartScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var water: SKSpriteNode!
    var water2: SKSpriteNode!
    var clouds: SKEmitterNode!
    
    let fixedDelta: CFTimeInterval = 1.0/60.0
    let scrollSpeed: CGFloat = 160
    
    override func didMoveToView(view: SKView) {
        water = self.childNodeWithName("water") as! SKSpriteNode
        water2 = self.childNodeWithName("water2") as! SKSpriteNode
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        
        clouds.advanceSimulationTime(100)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            skView.showsFPS = true
            skView.showsNodeCount = true
            //skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            skView.presentScene(scene)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
}