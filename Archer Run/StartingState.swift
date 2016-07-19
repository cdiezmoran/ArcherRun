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
        scene.archer.jump()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.startingScrollLayer.position.x -= 8
        scene.startTreesFront.position.x -= 8
        scene.startTreesBack.position.x -= 8
        scene.startMountains.position.x -= 8
        
        scene.mountains1.position.x -= 8
        scene.mountains2.position.x -= 8
        scene.treesBack1.position.x -= 8
        scene.treesBack2.position.x -= 8
        scene.treesFront1.position.x -= 8
        scene.treesFront2.position.x -= 8
        
        scene.levelHolder1.position.x -= 8
        scene.levelHolder2.position.x -= 8
    }
}
