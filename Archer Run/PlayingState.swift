//
//  PlayingState.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        addSpriteToScene(Spike())
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.score += 1
        
        if scene.timer >= Double(scene.randomInterval) {
            addSpriteToScene(Spike())
            scene.timer = 0
            scene.randomInterval = CGFloat.random(min: 0.3, max: 1.25)
        }
        
        scene.timer += scene.fixedDelta
        
    /*--------------------------------------------------------------------------------------*/
        //Scroll rest of starting world
        scrollStartingWorldLayer(scene.startingScrollLayer, speed: 6)
        scrollStartingWorldElement(scene.startTreesFront, speed: 4)
        scrollStartingWorldElement(scene.startTreesBack, speed: 2)
        scrollStartingWorldElement(scene.startMountains, speed: 0.5)
        
    /*--------------------------------------------------------------------------------------*/
        //Infinite Scroll
        scrollSprite(scene.levelHolder1, speed: 6)
        scrollSprite(scene.levelHolder2, speed: 6)
        scrollSprite(scene.mountains1, speed: 0.5)
        scrollSprite(scene.mountains2, speed: 0.5)
        scrollSprite(scene.treesBack1, speed: 2)
        scrollSprite(scene.treesBack2, speed: 2)
        scrollSprite(scene.treesFront1, speed: 4)
        scrollSprite(scene.treesFront2, speed: 4)
        scene.obstacleScrollLayer.position.x -= 6
    }
    
    func scrollStartingWorldElement(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollStartingWorldLayer(sprite: SKNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if scene.startingScrollLayer.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -(sprite.size.width / 2) {
            sprite.position.x += sprite.size.width * 2
        }
        
        if sprite.name == "levelHolder1" || sprite.name == "levelHolder2" {
            if sprite.position.x <= sprite.size.width + sprite.size.width/2 {
                scene.currentLevelHolder = sprite.name!
            }
        }
    }
    
    func addSpriteToScene(sprite: SKSpriteNode) {
        var newPosition: CGPoint!
        let x = scene.size.width
        let y = scene.levelHolder1.size.height + sprite.size.height / 2
        newPosition = CGPointMake(x, y)
        sprite.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
        scene.obstacleScrollLayer.addChild(sprite)
    }
    
    func addRandomEntity() {
        
    }
}
