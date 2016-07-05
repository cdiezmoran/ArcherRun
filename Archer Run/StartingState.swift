//
//  StartingState.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let jump = SKAction.moveByX(0, y: 50, duration: 0.5)
        let dropY = (scene.hero.position.y + 50) - 69
        let drop = SKAction.moveByX(0, y: -dropY, duration: 1)
        
        let jumpDrop = SKAction.sequence([jump, drop])
        
        let startPlaying = SKAction.runBlock {
            self.scene.gameState.enterState(PlayingState)
        }
        
        let startingAction = SKAction.sequence([jumpDrop, startPlaying])
        
        scene.hero.runAction(startingAction)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.startingScrollLayer.position.x -= 8
        scene.levelHolder1.position.x -= 8
        scene.levelHolder2.position.x -= 8
    }
}
