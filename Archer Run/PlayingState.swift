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
    var heartTimer: CFTimeInterval = 1
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnter(from previousState: GKState?) {
        compoundObjects = CompoundObjects(scene: scene)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.score += scene.floorSpeed * CGFloat(seconds)
        
        scene.floorSpeed += 0.001
        if scene.score < 10 {
            scene.floorSpeed = 4
        }
                
        if scene.floorSpeed > 8 {
            scene.floorSpeed = 8
        }
        
        if scene.score > 1500 {
            scene.intervalMin = 0.2
            scene.intervalMax = 0.4
        }
        else if scene.floorSpeed >= 4 && scene.floorSpeed < 6 {
            scene.intervalMin = 0.6
            scene.intervalMax = 1
        }
        else if scene.floorSpeed >= 6 && scene.floorSpeed < 8 {
            scene.intervalMin = 0.4
            scene.intervalMax = 1
        }
        else if scene.floorSpeed >= 8 {
            scene.intervalMin = 0.2
            scene.intervalMax = 1
        }
        
        /*--------------------------------------------------------------------------------------*/
        
        if scene.score >= 10 {
           addRandomEntity()
        }
        
        //add heart every 100m
        if round(scene.score).truncatingRemainder(dividingBy: 100) == 0 && round(scene.score) >= 100 {
            if heartTimer >= 1 {
                addSpriteToScene(Heart())
                heartTimer = 0
            }
        }
        heartTimer += scene.deltaTime
        
        /*--------------------------------------------------------------------------------------*/
        
        scene.scrollWorld(seconds)
        
        /*--------------------------------------------------------------------------------------*/
        if ChallengeManager.sharedInstance.notifyOnChallengeCompletion() {
            let changeText = SKAction.run({
                self.scene.challengeCompletedLabel.text = ChallengeManager.sharedInstance.challengeCompleted.description()
            })
            let showBanner = SKAction.moveTo(y: 355, duration: 0.5)
            let wait = SKAction.wait(forDuration: 1)
            let hideBanner = SKAction.moveTo(y: 446.5, duration: 1)
            
            let bannerSequence = SKAction.sequence([changeText, showBanner, wait, hideBanner])
            
            scene.challengeCompletedBanner.run(bannerSequence)
            scene.didCompleteChallenge = true
        }
    }
    
    func addSpriteToScene(_ sprite: SKSpriteNode) {
        let x = scene.size.width + sprite.size.width
        let y = scene.levelHolder1.size.height + sprite.size.height / 2
        let newPosition = CGPoint(x: x, y: y)
        
        if sprite.isKind(of: MeleeOrc.self) {
            let randomSelector = CGFloat.random(min: 0, max: 1)
            if randomSelector <= 0.4 {
                sprite.position = scene.convert(newPosition, to: scene.enemyScrollLayer)
                scene.enemyScrollLayer.addChild(sprite)
            }
            else if randomSelector > 0.4 && randomSelector <= 0.8 {
                sprite.position = scene.convert(newPosition, to: scene.enemyScrollLayerSlow)
                scene.enemyScrollLayerSlow.addChild(sprite)
            }
            else if randomSelector > 0.8 {
                sprite.position = scene.convert(newPosition, to: scene.enemyScrollLayerFast)
                scene.enemyScrollLayerFast.addChild(sprite)
            }
        }
        else if sprite.isKind(of: Heart.self) {
            sprite.position = scene.convert(newPosition, to: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
            sprite.position.y += sprite.size.height
        }
        else {
            sprite.position = scene.convert(newPosition, to: scene.obstacleScrollLayer)
            scene.obstacleScrollLayer.addChild(sprite)
        }
    }
    
    func addRandomEntity() {
        if scene.timer >= Double(scene.randomInterval) {
            let randomSelector = CGFloat.random(min: 0, max: 1)
            
            if randomSelector > 0 && randomSelector <= 0.55 {
                //Orc or Spike
                generateOrcOrSpike()
            }
            else if randomSelector > 0.55 && randomSelector <= 0.8 {
                //Coin block
                compoundObjects.generateCoinBlock()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.8 && randomSelector <= 0.975 && scene.score >= 40 {
                //Target
                compoundObjects.generateSpikesWithTarget()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.8 && randomSelector <= 0.975 && scene.score < 40 {
                //Coin Block
                compoundObjects.generateCoinBlock()
                changeIntervalForLargeObject()
            }
            else if randomSelector > 0.975 && scene.score >= 100 {
                //Undead
                scene.gameState.enter(BossState.self)
            }
            else if randomSelector > 0.975 && scene.score < 100 {
                //Orc or Spike
                generateOrcOrSpike()
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
