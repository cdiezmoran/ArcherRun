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
    
    override func didEnter(from previousState: GKState?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "removeAds"), object: nil)
        
        if scene.playedGames % 5 == 0 && !scene.didGetExtraChance {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showInterstitial"), object: nil)
        }

        moveAndShowSoundButtons()
        
        displayGameOverScreen()
        
        //Get current highscore and coin count
        let userDefaults = UserDefaults.standard
        var highscore = userDefaults.integer(forKey: "highscore")
        var totalCoinCount = userDefaults.integer(forKey: "totalCoins")
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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let moveSpeed = CGFloat(60 * seconds)
        
        scene.enemyScrollLayer.position.x -= moveSpeed
        scene.enemyScrollLayerSlow.position.x -= moveSpeed
        scene.enemyScrollLayerFast.position.x -= moveSpeed
    }
    
    func moveAndShowSoundButtons() {
        let moveAndShowSoundButtons = SKAction.run({
            let soundsPos = CGPoint(x: 193, y: -15.5)
            let musicPos = CGPoint(x: 275, y: -15.5)
            
            self.scene.soundsOn.position = soundsPos
            self.scene.soundsOff.position = soundsPos
            
            self.scene.musicOn.position = musicPos
            self.scene.musicOff.position = musicPos
            
            self.scene.toggleMusicAndSoundVisibility()

        })
        
        scene.run(moveAndShowSoundButtons)
    }
    
    func displayGameOverScreen() {
        let displayGameOverScreen = SKAction(named: "DisplayGameOver")!
        if scene.didCompleteChallenge {
            scene.gameOverScreen.run(displayGameOverScreen)
            let moveLevelInfo = SKAction.move(to: CGPoint(x: -124.5, y: -120), duration: 0.75)
            scene.levelInfoHolder.run(moveLevelInfo)
        }
        else {
            let waitForDeadAnimation = SKAction.wait(forDuration: 0.8)
            gameOverSequence = SKAction.sequence([waitForDeadAnimation, displayGameOverScreen])
            
            scene.gameOverScreen.run(gameOverSequence)
            scene.levelInfoHolder.position = CGPoint(x: -124.5, y: -120)
            scene.levelInfoHolder.zPosition = 1
        }
    }
}
