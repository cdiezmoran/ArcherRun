//
//  Target.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/19/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Target: SKSpriteNode {
    
    let defaultTexture = SKTexture(imageNamed: "target")
    
    init() {
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: defaultTexture.size())
        
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(texture: defaultTexture, size: defaultTexture.size())
        
        body.allowsRotation = false
        
        body.mass *= 0.5
        
        body.categoryBitMask = PhysicsCategory.Target
        body.collisionBitMask = PhysicsCategory.Arrow
        body.contactTestBitMask = PhysicsCategory.Arrow
        
        physicsBody = body
    }
}
