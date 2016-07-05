//
//  Hero.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/2/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Hero: SKSpriteNode {
    
    func createPhysicsBody() {
        let heroPhysicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        
        heroPhysicsBody.affectedByGravity = true
        heroPhysicsBody.usesPreciseCollisionDetection = true
        heroPhysicsBody.allowsRotation = false
        heroPhysicsBody.dynamic = true
        
        heroPhysicsBody.categoryBitMask = PhysicsCategory.Player
        heroPhysicsBody.collisionBitMask = PhysicsCategory.Floor
        heroPhysicsBody.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin
        
        self.physicsBody = heroPhysicsBody
    }
    
    func jump() {
        self.physicsBody?.applyForce(CGVector(dx: 0, dy: 250))
    }
}
