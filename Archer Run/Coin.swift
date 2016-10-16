//
//  Coin.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/18/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    
    let coinTexture = SKTexture(imageNamed: "coinGold")

    
    init() {
        super.init(texture: coinTexture, color: UIColor.clear, size: CGSize(width: 20, height: 20))
        
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(circleOfRadius: 5)
        
        body.affectedByGravity = false
        body.isDynamic = false
        body.allowsRotation = false
        
        body.categoryBitMask = PhysicsCategory.Coin
        body.collisionBitMask = PhysicsCategory.None
        body.contactTestBitMask = PhysicsCategory.Player
        
        self.physicsBody = body
    }
}
