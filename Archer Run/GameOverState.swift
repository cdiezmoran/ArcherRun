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
        NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)

        let displayGameOverScreen = SKAction(named: "DisplayGameOver")!
        if scene.didCompleteChallenge {
            scene.gameOverScreen.runAction(displayGameOverScreen)
            let moveLevelInfo = SKAction.moveTo(CGPoint(x: -124.5, y: -120), duration: 0.75)
            scene.levelInfoHolder.runAction(moveLevelInfo)
        }
        else {
            let waitForDeadAnimation = SKAction.waitForDuration(0.8)
            gameOverSequence = SKAction.sequence([waitForDeadAnimation, displayGameOverScreen])
            
            scene.gameOverScreen.runAction(gameOverSequence)
            scene.levelInfoHolder.position = CGPoint(x: -124.5, y: -120)
            scene.levelInfoHolder.zPosition = 1
        }
        
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
        
        scene.levelProgressBar.xScale = LevelManager.sharedInstance.getLastProgressBarXScale()
        ChallengeManager.sharedInstance.cleanUpOnGameOver()
        
        scene.setChallengeLabels()
        scene.setProgressLabels()
        scene.setChallengeIcons()
        
        ChallengeManager.sharedInstance.storeChallengesData()
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
}
