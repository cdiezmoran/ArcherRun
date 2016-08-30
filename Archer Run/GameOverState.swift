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
        
        moveAndShowSoundButtons()
        
        displayGameOverScreen()
        
        //Get current highscore and coin count
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var highscore = userDefaults.integerForKey("highscore")
        var totalCoinCount = userDefaults.integerForKey("totalCoins")
        let roundedScore = Int(round(scene.score))
        
        //Update highscore if user's score is better
        if roundedScore > highscore {
            userDefaults.setValue(roundedScore, forKey: "highscore")
            highscore = roundedScore
        }
        
        //Update coin count
        totalCoinCount += scene.coinCount
        
        //Save values to defaults
        userDefaults.setValue(totalCoinCount, forKey: "totalCoins")
        userDefaults.setValue(scene.playedGames + 1, forKey: "playedGames")
        userDefaults.synchronize()
        
        //Update Labels
        scene.scoreLabelGO.text = "\(roundedScore)m"
        scene.highScoreLabel.text = "\(highscore)m"
        scene.totalCoinCountLabel.text = String(totalCoinCount)
        
        //Update level progressbar and manage challenges
        if previousState is ChallengeCompletedState {
            LevelManager.sharedInstance.lastProgress = LevelManager.sharedInstance.progress
        }
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
        let moveSpeed = CGFloat(60 * seconds)
        
        scene.enemyScrollLayer.position.x -= moveSpeed
        scene.enemyScrollLayerSlow.position.x -= moveSpeed
        scene.enemyScrollLayerFast.position.x -= moveSpeed
    }
    
    func moveAndShowSoundButtons() {
        let moveAndShowSoundButtons = SKAction.runBlock({
            let soundsPos = CGPoint(x: 193, y: -15.5)
            let musicPos = CGPoint(x: 275, y: -15.5)
            
            self.scene.soundsOn.position = soundsPos
            self.scene.soundsOff.position = soundsPos
            
            self.scene.musicOn.position = musicPos
            self.scene.musicOff.position = musicPos
            
            self.scene.toggleMusicAndSoundVisibility()

        })
        
        scene.runAction(moveAndShowSoundButtons)
    }
    
    func displayGameOverScreen() {
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
    }
}
