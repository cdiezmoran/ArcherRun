//
//  Spike.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/11/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Spike: SKSpriteNode {
    
    let spikeTexture: SKTexture? = SKTexture(imageNamed: "spikes")
    let spikeSize: CGSize = CGSize(width: 35, height: 35)
    let spikeColor: UIColor = UIColor.whiteColor()
    
    init() {
        super.init(texture: spikeTexture, color: spikeColor, size: spikeSize)
        
        self.zPosition = 1
        self.setupPhysicsBody(spikeTexture!, size: spikeSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicsBody(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
