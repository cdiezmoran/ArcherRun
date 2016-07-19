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
        userDefaults.setValue(scene.coinCount, forKey: "coinCount")
        userDefaults.synchronize()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.enemyScrollLayer.position.x -= 6.5
    }
}
