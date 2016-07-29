//
//  Undead.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/28/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Undead: SKSpriteNode {
    
    var idleAnimation: SKAction!
    var shootAnimation: SKAction!
    var deadAnimation: SKAction!
    
    init() {
        let defaultTexture = SKTexture(imageNamed: "unIdle-1")
        let size = CGSize(width: 50, height: 50)
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: size)
        
        xScale = -1
        createPhysicsBody()
        
        var textures = [SKTexture]()
        
        //IDLE ANIMATION
        textures = getTextures("unIdle-", total: 6)
        
        let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        
        idleAnimation = SKAction.repeatActionForever(animate)
        runAction(idleAnimation)
        
        //SHOOT ANIMATION
        textures = getTextures("unShoot-", total: 5)
        shootAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.075, resize: true, restore: false)
        
        //DEAD ANIMATION
        textures = getTextures("unDead-", total: 5)
        deadAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.075, resize: true, restore: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 26, height: 47), center: CGPoint(x: -5.5, y: 0.15))
        
        body.affectedByGravity = true
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.dynamic = true
        
        body.restitution = 0
        
        body.categoryBitMask = PhysicsCategory.Obstacle
        body.collisionBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Arrow
        
        physicsBody = body
    }
    
    func die() {
        removeAllActions()
        
        runAction(deadAnimation)
    }
    
    func shoot() {
        removeAllActions()
        let waitAction = SKAction.waitForDuration(5*0.075)
        let sequence = SKAction.sequence([shootAnimation, waitAction, idleAnimation])
        runAction(sequence)
    }
    
    func getTextures(prefix: String, total: Int) -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for index in 1...total {
            let textureName = prefix + String(index)
            let texture = SKTexture(imageNamed: textureName)
            textures.append(texture)
        }
        
        return textures
    }
}
