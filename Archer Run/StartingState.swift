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
    
    override func didEnter(from previousState: GKState?) {
        scene.archer.jump()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let pixelsToMove = CGFloat(360 * seconds)
        scene.startingScrollLayer.position.x -= pixelsToMove
        scene.startTreesFront.position.x -= pixelsToMove
        scene.startTreesBack.position.x -= pixelsToMove
        scene.startMountains.position.x -= pixelsToMove
        
        scene.mountains1.position.x -= pixelsToMove
        scene.mountains2.position.x -= pixelsToMove
        scene.treesBack1.position.x -= pixelsToMove
        scene.treesBack2.position.x -= pixelsToMove
        scene.treesFront1.position.x -= pixelsToMove
        scene.treesFront2.position.x -= pixelsToMove
        
        scene.levelHolder1.position.x -= pixelsToMove
        scene.levelHolder2.position.x -= pixelsToMove
    }
}
