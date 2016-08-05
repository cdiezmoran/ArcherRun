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
        scene.score += scene.floorSpeed * CGFloat(seconds)
        
        scene.floorSpeed += 0.00075
        if scene.score < 10 {
            scene.floorSpeed = 4
        }
                
        if scene.floorSpeed > 8 {
            scene.floorSpeed = 8
        }
        
        if scene.floorSpeed >= 4 && scene.floorSpeed < 6 {
            scene.intervalMin = 0.5
            scene.intervalMax = 1
        }
        else if scene.floorSpeed >= 6 && scene.floorSpeed < 8 {
            scene.intervalMin = 0.5
            scene.intervalMax = 1.05
        }
        else if scene.floorSpeed >= 8 {
            scene.intervalMin = 0.5
            scene.intervalMax = 1.1
        }
        
        /*--------------------------------------------------------------------------------------*/
        
        if scene.score >= 10 {
           addRandomEntity()
        }
        
        /*--------------------------------------------------------------------------------------*/
        
        scene.scrollWorld(seconds)
        
        /*--------------------------------------------------------------------------------------*/
        if ChallengeManager.sharedInstance.notifyOnChallengeCompletion() {
            let changeText = SKAction.runBlock({
                self.scene.challengeCompletedLabel.text = ChallengeManager.sharedInstance.challengeCompleted.description()
            })
            let showBanner = SKAction.moveToY(381.5, duration: 0.5)
            let wait = SKAction.waitForDuration(1)
            let hideBanner = SKAction.moveToY(446.5, duration: 1)
            
            let bannerSequence = SKAction.sequence([changeText, showBanner, wait, hideBanner])
            
            scene.challengeCompletedBanner.runAction(bannerSequence)
        }
    }
    
    func addSpriteToScene(sprite: SKSpriteNode) {
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + sprite.size.height / 2
        let newPosition = CGPointMake(x, y)
        
        if sprite.isKindOfClass(MeleeOrc) {
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
        else if sprite.isKindOfClass(Heart) {
            sprite.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
            sprite.position.y += sprite.size.height
        }
        else {
            sprite.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
        }
    }
    
    func addRandomEntity() {
        if scene.timer >= Double(scene.randomInterval) {
            let randomSelector = CGFloat.random(min: 0, max: 1)
            
            if randomSelector > 0 && randomSelector <= 0.5 {
                //Orc or Spike
                generateOrcOrSpike()
            }
            else if randomSelector > 0.5 && randomSelector <= 0.75 {
                //Coin block
                compoundObjects.generateCoinBlock()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.75 && randomSelector <= 0.9 && scene.score >= 60 {
                //Target
                compoundObjects.generateSpikesWithTarget()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.75 && randomSelector <= 0.9 && scene.score < 60 {
                //Coin Block
                compoundObjects.generateCoinBlock()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.9 && randomSelector <= 0.975 && scene.score >= 40 {
                //Undead
                scene.gameState.enterState(UndeadState)
            }
            else if randomSelector > 0.9 && randomSelector <= 0.975 && scene.score < 40 {
                //Orc or Spike
                generateOrcOrSpike()
            }
            else if randomSelector > 0.975 {
                //heart
                addSpriteToScene(Heart())
            }
            
            scene.timer = 0
            scene.randomInterval = CGFloat.random(min: scene.intervalMin, max: scene.intervalMax)
        }
        
        scene.timer += scene.deltaTime
    }
    
    func generateOrcOrSpike() {
        let random = CGFloat.random(min: 0, max: 1)
        if random > 0 && random <= 0.65 {
            addSpriteToScene(Spike())
        }
        else if random > 0.65 {
            addSpriteToScene(MeleeOrc())
        }
    }
    
    func changeIntervalForLargeObject() {
        if scene.intervalMin < 1 {
            scene.intervalMin = 1
            if scene.intervalMax <= 1 {
                scene.intervalMax = 1.1
            }
        }
    }
}
