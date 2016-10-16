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
    
    var isMoving: Bool = false
    var isPositioned: Bool = false
    var lives: Int = 2
    var state: EntityState = .none
    
    init() {
        let defaultTexture = SKTexture(imageNamed: "unIdle-1")
        super.init(texture: defaultTexture, color: UIColor.clear, size: defaultTexture.size())
        
        xScale = -1
        createPhysicsBody()
        
        var textures = [SKTexture]()
        
        //IDLE ANIMATION
        textures = getTextures("unIdle-", total: 6)
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        
        idleAnimation = SKAction.repeatForever(animate)
        run(idleAnimation)
        
        //SHOOT ANIMATION
        textures = getTextures("unShoot-", total: 5)
        shootAnimation = SKAction.animate(with: textures, timePerFrame: 0.025, resize: true, restore: false)
        
        //DEAD ANIMATION
        textures = getTextures("unDead-", total: 5)
        deadAnimation = SKAction.animate(with: textures, timePerFrame: 0.0075, resize: true, restore: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 34, height: 62), center: CGPoint(x: 7.5, y: 0.4))
        
        body.affectedByGravity = false
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.isDynamic = false
        
        body.restitution = 0
        
        body.categoryBitMask = PhysicsCategory.Obstacle
        body.collisionBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Arrow
        
        physicsBody = body
    }
    
    func die() {
        removeAllActions()
        
        run(deadAnimation)
        
        state = .dead
    }
    
    func shoot() {
        removeAllActions()
        let waitAction = SKAction.wait(forDuration: shootAnimation.duration)
        let sequence = SKAction.sequence([shootAnimation, waitAction, idleAnimation])
        run(sequence)
    }
    
    func getTextures(_ prefix: String, total: Int) -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for index in 1...total {
            let textureName = prefix + String(index)
            let texture = SKTexture(imageNamed: textureName)
            textures.append(texture)
        }
        
        return textures
    }
}
