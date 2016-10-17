//
//  PauseState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/29/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class PauseState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.pauseScreen.isHidden = false
        scene.toggleMusicAndSoundVisibility()
        
        scene.archer.removeAllActions()
        scene.archer.physicsBody?.isDynamic = false
        
        scene.removeOrcActionsFor(parentNode: scene.enemyScrollLayer)
        scene.removeOrcActionsFor(parentNode: scene.enemyScrollLayerFast)
        scene.removeOrcActionsFor(parentNode: scene.enemyScrollLayerSlow)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        //resume animations
        scene.archer.doRunAnimation()
        scene.archer.physicsBody?.isDynamic = true
        scene.archer.resetRotation()
        
        scene.makeOrcsRunFor(parentNode: scene.enemyScrollLayer)
        scene.makeOrcsRunFor(parentNode: scene.enemyScrollLayerFast)
        scene.makeOrcsRunFor(parentNode: scene.enemyScrollLayerSlow)
    }
}
