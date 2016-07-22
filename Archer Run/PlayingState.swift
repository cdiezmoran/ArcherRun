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
        scene.score += 30 * CGFloat(seconds)
        
        var floorSpeed: CGFloat = 4
        floorSpeed += 0.0005
        if scene.score < 500 {
            floorSpeed = 4
        }
        
        if floorSpeed > 9 {
            floorSpeed = 9
        }
        
        if floorSpeed >= 4 && floorSpeed < 6 {
            scene.intervalMin = 0.5
            scene.intervalMax = 1.25
        }
        else if floorSpeed >= 6 && floorSpeed < 8 {
            scene.intervalMin = 0.8
            scene.intervalMax = 1.5
        }
        else if floorSpeed >= 8 && floorSpeed <= 9 {
            scene.intervalMin = 1.25
            scene.intervalMax = 2
        }
        
        /*--------------------------------------------------------------------------------------*/
        
        if scene.timer >= Double(scene.randomInterval) {
            let randomSelector = CGFloat.random(min: 0, max: 1)
            
            if randomSelector > 0 && randomSelector <= 0.3 {
                addSpriteToScene(MeleeOrc(), isEnemy: true)
            }
            else if randomSelector > 0.3 && randomSelector <= 0.6 {
                addSpriteToScene(Spike(), isEnemy: false)
            }
            else if randomSelector > 0.6 && randomSelector <= 0.9 {
                compoundObjects.generateCoinBlock()
            }
            else if randomSelector > 0.9 && scene.score >= 500 {
                compoundObjects.generateSpikesWithTarget()
                scene.intervalMin = 1
            }
            else if randomSelector > 0.9 && scene.score < 500 {
                compoundObjects.generateCoinBlock()
            }
            
            scene.timer = 0
            scene.randomInterval = CGFloat.random(min: scene.intervalMin, max: scene.intervalMax)
        }
        
        scene.timer += scene.fixedDelta
        
        /*--------------------------------------------------------------------------------------*/
        
        let secondsFloat = CGFloat(seconds)
        
        let scrollSpeed = (floorSpeed * 60) * secondsFloat
        let treesFrontSpeed = (2 * 60) * secondsFloat
        let treesBackSpeed = 60 * secondsFloat
        let mountainsSpeed = 30 * secondsFloat
        let enemyScrollSpeedSlow = ((floorSpeed + 1) * 60) * secondsFloat
        let enemyScrollSpeed = ((floorSpeed + 2) * 60) * secondsFloat
        let enemyScrollSpeedFast = ((floorSpeed + 3) * 60) * secondsFloat
        
        //Scroll rest of starting world
        scrollStartingWorldLayer(scene.startingScrollLayer, speed: scrollSpeed)
        scrollStartingWorldElement(scene.startTreesFront, speed: treesFrontSpeed)
        scrollStartingWorldElement(scene.startTreesBack, speed: treesBackSpeed)
        scrollStartingWorldElement(scene.startMountains, speed: mountainsSpeed)
        
        //Infinite Scroll
        scrollSprite(scene.levelHolder1, speed: scrollSpeed)
        scrollSprite(scene.levelHolder2, speed: scrollSpeed)
        scrollSprite(scene.mountains1, speed: mountainsSpeed)
        scrollSprite(scene.mountains2, speed: mountainsSpeed)
        scrollSprite(scene.treesBack1, speed: treesBackSpeed)
        scrollSprite(scene.treesBack2, speed: treesBackSpeed)
        scrollSprite(scene.treesFront1, speed: treesFrontSpeed)
        scrollSprite(scene.treesFront2, speed: treesFrontSpeed)
        
        scene.obstacleScrollLayer.position.x -= scrollSpeed
        scene.enemyScrollLayer.position.x -= enemyScrollSpeed
        scene.enemyScrollLayerSlow.position.x -= enemyScrollSpeedSlow
        scene.enemyScrollLayerFast.position.x -= enemyScrollSpeedFast
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
            let randomSelector = CGFloat.random(min: 0, max: 1)
            if randomSelector <= 0.4 {
                sprite.position = scene.convertPoint(newPosition, toNode: scene.enemyScrollLayer)
                scene.enemyScrollLayer.addChild(sprite)
            }
            else if randomSelector > 0.4 && randomSelector <= 0.8 {
                sprite.position = scene.convertPoint(newPosition, toNode: scene.enemyScrollLayerSlow)
                scene.enemyScrollLayerSlow.addChild(sprite)
            }
            else if randomSelector > 0.8 {
                sprite.position = scene.convertPoint(newPosition, toNode: scene.enemyScrollLayerFast)
                scene.enemyScrollLayerFast.addChild(sprite)
            }
        }
        else {
            sprite.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
        }
    }
    
    func addRandomEntity() {
        
    }
}
