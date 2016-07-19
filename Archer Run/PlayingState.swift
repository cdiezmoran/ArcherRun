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
    
    var compoundObjects: CompoundObjects!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        compoundObjects = CompoundObjects(scene: scene)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.score += 1
        
        if scene.timer >= Double(scene.randomInterval) {
            let randomSelector = CGFloat.random(min: 0, max: 1)
            
            if randomSelector > 0 && randomSelector <= 0.3 {
                addSpriteToScene(MeleeOrc(), isEnemy: true)
            }
            else if randomSelector > 0.3 && randomSelector <= 0.6 {
                addSpriteToScene(Spike(), isEnemy: false)
            }
            else if randomSelector > 0.6 && randomSelector <= 0.8 {
                compoundObjects.generateCoinBlock()
            }
            else if randomSelector > 0.8 {
                compoundObjects.generateSpikesWithTarget()
            }
            
            scene.timer = 0
            scene.randomInterval = CGFloat.random(min: 0.5, max: 1.25)
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
        scene.enemyScrollLayer.position.x -= 6.5
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
    
    func addSpriteToScene(sprite: SKSpriteNode, isEnemy: Bool) {
        var newPosition: CGPoint!
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + sprite.size.height / 2
        newPosition = CGPointMake(x, y)
        
        if isEnemy {
            sprite.position = scene.convertPoint(newPosition, toNode: scene.enemyScrollLayer)
            scene.enemyScrollLayer.addChild(sprite)
        }
        else {
            sprite.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
        }
    }
    
    func addRandomEntity() {
        
    }
}
