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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.challengeCompletedScreen.zPosition = 0
        scene.levelInfoHolder.zPosition = 1
        
        //ChallengeManager.sharedInstance.cleanUpOnGameOver()
        scene.setProgressLabels()
        let completedChallenges = ChallengeManager.sharedInstance.checkForCompletedChallenges()
        var actions = [SKAction]()
        
        for (key, challenge) in completedChallenges {
            switch key {
            case "firstChallenge":
                actions += challengeCompletedSequence(challenge)
                break
            case "secondChallenge":
                actions += challengeCompletedSequence(challenge)
                break
            case "thirdChallenge":
                actions += challengeCompletedSequence(challenge)
                break
            default:
                break
            }
        }
        
        let goToGameOver = SKAction.runBlock({
            self.scene.gameState.enterState(GameOverState)
        })
        
        actions.append(goToGameOver)
        
        let sequence = SKAction.sequence(actions)
        
        scene.challengeHolder.runAction(sequence)
        
        ChallengeManager.sharedInstance.storeChallengesData()
        LevelManager.sharedInstance.storeLevelData()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.enemyScrollLayer.position.x -= 4
        scene.enemyScrollLayerSlow.position.x -= 4
        scene.enemyScrollLayerFast.position.x -= 4
    }
    
    func challengeCompletedSequence(challenge: Challenge) -> [SKAction] {
        var actions = [SKAction]()
        let particles = SKEmitterNode(fileNamed: "LevelUp")!
        
        //Update banner elements
        let updateBannerElements = SKAction.runBlock({
            self.scene.challengeLabel.text = challenge.description()
            self.scene.challengeCompletedIcon.texture = challenge.getTexture()
            self.scene.challengeCompletedIconBG.color = challenge.getBGColor()
        })
        //Move banner to view
        let showBanner = SKAction.moveToX(368, duration: 0.5)
        //wait for show banner
        let wait = SKAction.waitForDuration(showBanner.duration)
        //Display completed sprite
        let displayCompletedSprite = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            let completedSprite = node.childNodeWithName("completedSprite") as! SKSpriteNode
            completedSprite.xScale += elapsedTime / 0.5
            if completedSprite.xScale >= 1 {
                completedSprite.xScale = 1
                completedSprite.zPosition = 10
            }
        })
        //Give exp
        let giveExp = SKAction.runBlock({
            LevelManager.sharedInstance.gainExp()
        })
        //Update progress bar w/ last progress
        /*let updateLastProgressBar = SKAction.runBlock({
            self.scene.levelProgressBar.xScale = LevelManager.sharedInstance.getLastProgressBarXScale()
        })*/
        
        //Update progress bar
        let updateProgressBar = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            self.scene.levelProgressBar.xScale = ((LevelManager.sharedInstance.getProgressBarXScale() * elapsedTime) / 0.5) + LevelManager.sharedInstance.getLastProgressBarXScale()
            if self.scene.levelProgressBar.xScale >= 1 {
                self.scene.levelProgressBar.xScale = 1
            }
            else if self.scene.levelProgressBar.xScale <= 0 {
                self.scene.levelProgressBar.xScale = 0
            }
        })
        //Update level label
        let updateLevelLabel = SKAction.runBlock({
            if LevelManager.sharedInstance.didLevelUp {
                //do level up animation
                particles.position = self.scene.levelLabel.position
                self.scene.levelInfoHolder.addChild(particles)
                //update label
                self.scene.levelLabel.text = String(Int(LevelManager.sharedInstance.level))
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                var totalCoins = userDefaults.integerForKey("totalCoins")
                let reward = LevelManager.sharedInstance.lastExpRequired / 4
                totalCoins += reward
                userDefaults.setValue(totalCoins, forKey: "totalCoins")
                userDefaults.synchronize()
                
                self.scene.coinRewardLabel.hidden = false
                self.scene.coinRewardLabel.text = "+\(reward)"
                self.scene.totalCoinCountLabel.text = String(totalCoins)
                
                //set didLevelUp back to false
                LevelManager.sharedInstance.didLevelUp = false
            }
        })
        //Wait for display completed sprite
        //Hide completed sprite
        let hideCompletedSprite = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            let completedSprite = node.childNodeWithName("completedSprite") as! SKSpriteNode
            completedSprite.xScale -= elapsedTime / 0.5
            if completedSprite.xScale <= 0 {
                completedSprite.xScale = 0
            }
        })
        //Move banner out of screen
        let hideBanner = SKAction.moveToX(961, duration: 0.5)
        //Wait for banner out of screen duration
        //remove particles
        let removeParticles = SKAction.runBlock({
            particles.removeFromParent()
            self.scene.coinRewardLabel.hidden = true
        })
        //Reset banner position
        let resetBanner = SKAction.runBlock({
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
