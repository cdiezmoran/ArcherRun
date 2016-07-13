//
//  newArcher.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/12/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class newArcher: SKSpriteNode {
    
    
    
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOfSize: (texture?.size())!)
        physicsBody?.categoryBitMask = 3
        
    }
    
    
    init() {
        let texture = SKTexture(imageNamed: "")
        let archerSize = CGSize(width: 76, height: 66)
        super.init(texture: texture, color: UIColor.clearColor(), size: archerSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
