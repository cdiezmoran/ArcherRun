//
//  TutorialState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/21/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    
}
