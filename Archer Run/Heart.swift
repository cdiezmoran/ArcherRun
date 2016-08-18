//
//  Heart.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Heart: SKSpriteNode {
    
    init() {
        let defaultTexture = SKTexture(imageNamed: "heartFinal")
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
        
        zPosition = 51
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        body.affectedByGravity = false
        body.dynamic = false
        body.allowsRotation = false
        
        body.categoryBitMask = PhysicsCategory.Heart
        body.collisionBitMask = PhysicsCategory.None
        body.contactTestBitMask = PhysicsCategory.Player
        
        self.physicsBody = body
    }
    
}
