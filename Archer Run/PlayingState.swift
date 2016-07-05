//
//  PlayingState.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.hero.createPhysicsBody()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scrollRestOfStartingWorld()
        scrollSprite(scene.levelHolder1, speed: 8)
        scrollSprite(scene.levelHolder2, speed: 8)
    }
    
    func scrollRestOfStartingWorld() {
        scene.startingScrollLayer.position.x -= 8
        
        if scene.startingScrollLayer.position.x <= -(scene.frame.size.width + 200) {
            scene.startingScrollLayer.removeFromParent()
        }
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= 0 {
            sprite.position.x += sprite.size.width * 2
        }
    }
}
