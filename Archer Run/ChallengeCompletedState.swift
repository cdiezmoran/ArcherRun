//
//  ChallengeCompletedState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/11/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class ChallengeCompletedState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnter(from previousState: GKState?) {        
        scene.challengeCompletedScreen.zPosition = 0
        scene.levelInfoHolder.zPosition = 1
        
        //ChallengeManager.sharedInstance.cleanUpOnGameOver()
        scene.setProgressLabels()
        let completedChallenges = ChallengeManager.sharedInstance.checkForCompletedChallenges()
        var actions = [SKAction]()
        
        for (_, challenge) in completedChallenges {
            actions += challengeCompletedSequence(challenge)
        }
        
        let goToGameOver = SKAction.run({
            self.scene.gameState.enter(GameOverState.self)
        })
        
        actions.append(goToGameOver)
        
        let sequence = SKAction.sequence(actions)
        
        scene.challengeHolder.run(sequence)
        
        ChallengeManager.sharedInstance.storeChallengesData()
        LevelManager.sharedInstance.storeLevelData()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.enemyScrollLayer.position.x -= 4
        scene.enemyScrollLayerSlow.position.x -= 4
        scene.enemyScrollLayerFast.position.x -= 4
    }
    
    func challengeCompletedSequence(_ challenge: Challenge) -> [SKAction] {
        var actions = [SKAction]()
        let particles = SKEmitterNode(fileNamed: "LevelUp")!
        
        //Update banner elements
        let updateBannerElements = SKAction.run({
            self.scene.challengeLabel.text = challenge.description()
            self.scene.challengeCompletedIcon.texture = challenge.getTexture()
            self.scene.challengeCompletedIconBG.color = challenge.getBGColor()
        })
        //Move banner to view
        let showBanner = SKAction.moveTo(x: 368, duration: 0.5)
        //wait for show banner
        let wait = SKAction.wait(forDuration: showBanner.duration)
        //Display completed sprite
        let displayCompletedSprite = SKAction.customAction(withDuration: 0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            let completedSprite = node.childNode(withName: "completedSprite") as! SKSpriteNode
            completedSprite.xScale += elapsedTime / 0.5
            if completedSprite.xScale >= 1 {
                completedSprite.xScale = 1
                completedSprite.zPosition = 10
            }
        })
        //Give exp
        let giveExp = SKAction.run({
            LevelManager.sharedInstance.gainExp()
        })
        
        //Update progress bar
        let updateProgressBar = SKAction.customAction(withDuration: 0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            self.scene.levelProgressBar.xScale = ((LevelManager.sharedInstance.getProgressBarXScale() * elapsedTime) / 0.5) + LevelManager.sharedInstance.getLastProgressBarXScale()
            if self.scene.levelProgressBar.xScale >= 1 {
                self.scene.levelProgressBar.xScale = 1
            }
            else if self.scene.levelProgressBar.xScale <= 0 {
                self.scene.levelProgressBar.xScale = 0
            }
        })
        //Update level label
        let updateLevelLabel = SKAction.run({
            if LevelManager.sharedInstance.didLevelUp {
                //do level up animation
                particles.position = self.scene.levelLabel.position
                self.scene.levelInfoHolder.addChild(particles)
                //update label
                self.scene.levelLabel.text = String(Int(LevelManager.sharedInstance.level))
                
                let userDefaults = UserDefaults.standard
                var totalCoins = userDefaults.integer(forKey: "totalCoins")
                let reward = LevelManager.sharedInstance.lastExpRequired / 4
                totalCoins += reward
                userDefaults.setValue(totalCoins, forKey: "totalCoins")
                userDefaults.synchronize()
                
                self.scene.coinRewardLabel.isHidden = false
                self.scene.coinRewardLabel.text = "+\(reward)"
                self.scene.totalCoinCountLabel.text = String(totalCoins)
                
                //set didLevelUp back to false
                LevelManager.sharedInstance.didLevelUp = false
            }
        })
        //Wait for display completed sprite
        //Hide completed sprite
        let hideCompletedSprite = SKAction.customAction(withDuration: 0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            let completedSprite = node.childNode(withName: "completedSprite") as! SKSpriteNode
            completedSprite.xScale -= elapsedTime / 0.5
            if completedSprite.xScale <= 0 {
                completedSprite.xScale = 0
            }
        })
        //Move banner out of screen
        let hideBanner = SKAction.moveTo(x: 961, duration: 0.5)
        //Wait for banner out of screen duration
        //remove particles
        let removeParticles = SKAction.run({
            particles.removeFromParent()
            self.scene.coinRewardLabel.isHidden = true
        })
        //Reset banner position
        let resetBanner = SKAction.run({
            self.scene.challengeHolder.position = CGPoint(x: -225, y: 250)
        })
        
        actions.append(updateBannerElements)
        actions.append(showBanner)
        actions.append(wait)
        actions.append(displayCompletedSprite)
        actions.append(giveExp)
        actions.append(updateProgressBar)
        actions.append(updateLevelLabel)
        actions.append(wait)
        actions.append(hideCompletedSprite)
        actions.append(wait)
        actions.append(hideBanner)
        actions.append(wait)
        actions.append(removeParticles)
        actions.append(resetBanner)
        actions.append(wait)
        
        return actions
    }
}
