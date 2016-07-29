//
//  Arrow.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/14/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Arrow: SKSpriteNode {
    
    let defaultTexture = SKTexture(imageNamed: "arrow")
    let defaultSize = CGSize(width: 34.0, height: 8)
    
    init() {
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: defaultSize)
        
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(texture: defaultTexture, size: defaultSize)
        
        body.categoryBitMask = PhysicsCategory.Arrow
        body.collisionBitMask = PhysicsCategory.Target
        body.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Target
        
        physicsBody = body
    }
}
