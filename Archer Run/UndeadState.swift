//
//  UndeadState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/3/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class UndeadState: GKState {
    
    unowned let scene: GameScene
    
    var checkPosition: CGPoint!
    var undeadIsPositioned: Bool = false
    var undeadIsMoving: Bool = false
    var undead: Undead!
    
    init(scene: GameScene) {
        self.scene = scene
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        undead = Undead()
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + undead.size.height / 2
        undead.position = CGPointMake(x, y)
        checkPosition = undead.position
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if !undeadIsPositioned {
            if scene.obstacleScrollLayer.children.count == 0 {
                undead.position = scene.convertPoint(undead.position, toNode: scene.obstacleScrollLayer)
                scene.obstacleScrollLayer.addChild(undead)
                undeadIsMoving = true
            }
        }
        
        if undeadIsMoving {
            checkPosition = scene.convertPoint(undead.position, fromNode: scene.obstacleScrollLayer)
        }
        
        if !undeadIsPositioned {
            if checkPosition.x <= (scene.size.width * 7) / 8 {
                undead.position = scene.convertPoint(undead.position, fromNode: scene.obstacleScrollLayer)
                undead.removeFromParent()
                scene.addChild(undead)
                
                undeadIsMoving = false
                undeadIsPositioned = true
            }
        }
        
        scene.scrollWorld(seconds)
    }
}