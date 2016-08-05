//
//  GameOverState.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    
    unowned let scene: GameScene
    
    var gameOverSequence: SKAction!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let displayGameOverScreen = SKAction(named: "DisplayGameOver")!
        let waitForDeadAnimation = SKAction.waitForDuration(0.8)
        gameOverSequence = SKAction.sequence([waitForDeadAnimation, displayGameOverScreen])
        
        scene.archer.die()
        
        scene.gameOverScreen.runAction(gameOverSequence)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var highscore = userDefaults.integerForKey("highscore")
        var totalCoinCount = userDefaults.integerForKey("totalCoins")
        let roundedScore = Int(round(scene.score))
        
        if roundedScore > highscore {
            userDefaults.setValue(roundedScore, forKey: "highscore")
            highscore = roundedScore
        }
        
        totalCoinCount += scene.coinCount
        userDefaults.setValue(totalCoinCount, forKey: "totalCoins")
        userDefaults.setValue(scene.playedGames + 1, forKey: "playedGames")
        userDefaults.synchronize()
        
        scene.scoreLabelGO.text = "\(roundedScore)m"
        scene.highScoreLabel.text = "\(highscore)m"
        scene.totalCoinCountLabel.text = String(totalCoinCount)
        
        ChallengeManager.sharedInstance.cleanUpOnGameOver()
        scene.setProgressLabels()
        let completedKeys = ChallengeManager.sharedInstance.checkForCompletedChallenges()
        
        for key in completedKeys {
            switch key {
            case "firstChallenge":
                let sequence = SKAction.sequence(challengeCompletedSequence())
                scene.firstCompletedSprite.runAction(sequence)
                break
            case "secondChallenge":
                let sequence = SKAction.sequence(challengeCompletedSequence())
                scene.secondCompletedSprite.runAction(sequence)
                break
            case "thirdChallenge":
                let sequence = SKAction.sequence(challengeCompletedSequence())
                scene.thirdCompletedSprite.runAction(sequence)
                break
            default:
                break
            }
        }
        
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
    
    func challengeCompletedSequence() -> [SKAction] {
        var actionsArray = [SKAction]()
        let particles = SKEmitterNode(fileNamed: "LevelUp")!
        
        let waitForGameOverSequence = SKAction.waitForDuration(gameOverSequence.duration)
        
        //Show completed sprite (using xScale)
        let showAction = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            node.xScale += elapsedTime / 0.5
            if node.xScale >= 1 {
                node.xScale = 1
                node.zPosition = 10
            }
        })
        //Give exp
        let giveExp = SKAction.runBlock({ LevelManager.sharedInstance.gainExp() })
        //Wait for a second
        let wait = SKAction.waitForDuration(1)
        //Hide completed sprite
        let hideAction = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            node.xScale -= elapsedTime / 0.5
            if node.xScale <= 0 {
                node.xScale = 0
            }
        })
        //Update labels
        let updateLabels = SKAction.runBlock({
            self.scene.setChallengeLabels()
            self.scene.setProgressLabels()
        })
        
        let updateProgressBar = SKAction.customActionWithDuration(0.5, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) in
            self.scene.levelProgressBar.xScale = (LevelManager.sharedInstance.getProgressBarXScale() * elapsedTime) / 0.5
            if self.scene.levelProgressBar.xScale >= 1 {
                self.scene.levelProgressBar.xScale = 1
            }
            else if self.scene.levelProgressBar.xScale <= 0 {
                self.scene.levelProgressBar.xScale = 0
            }
        })
         
        let updateLevelLabel = SKAction.runBlock({
            if LevelManager.sharedInstance.didLevelUp {
                //do level up animation
                particles.position = self.scene.levelLabel.position
                self.scene.gameOverScreen.addChild(particles)
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
        
        let removeParticles = SKAction.runBlock({
            particles.removeFromParent()
            self.scene.coinRewardLabel.hidden = true
        })
        
        actionsArray.append(waitForGameOverSequence)
        actionsArray.append(showAction)
        actionsArray.append(giveExp)
        actionsArray.append(updateProgressBar)
        actionsArray.append(updateLevelLabel)
        actionsArray.append(wait)
        actionsArray.append(hideAction)
        actionsArray.append(updateLabels)
        actionsArray.append(removeParticles)
        
        return actionsArray
    }
}
