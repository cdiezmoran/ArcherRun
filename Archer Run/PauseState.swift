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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.pauseScreen.hidden = false
        scene.toggleMusicAndSoundVisibility()
        
        scene.archer.removeAllActions()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        //resume animations
        scene.archer.doRunAnimation()
    }
}