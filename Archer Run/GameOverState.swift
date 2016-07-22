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
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let displayGameOverScreen = SKAction(named: "DisplayGameOver")!
        let waitForDeadAnimation = SKAction.waitForDuration(0.8)
        let gameOverSequence = SKAction.sequence([waitForDeadAnimation, displayGameOverScreen])
        
        scene.archer.die()
        
        scene.gameOverScreen.runAction(gameOverSequence)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var highscore = userDefaults.integerForKey("highscore")
        let roundedScore = Int(round(scene.score))
        
        if roundedScore > highscore {
            userDefaults.setValue(roundedScore, forKey: "highscore")
            highscore = roundedScore
        }
        
        userDefaults.setValue(scene.playedGames + 1, forKey: "playedGames")
        userDefaults.synchronize()
        
        scene.scoreLabelGO.text = "\(roundedScore)m"
        scene.highScoreLabel.text = "\(highscore)m"
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
