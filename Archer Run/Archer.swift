//
//  Hero.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/2/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum EntityState {
    case None, Jumping, Running, Dead, DoubleJumping, Hurt, HurtJump, HurtDoubleJump
}

class Archer: SKSpriteNode {
    
    var deadAnimation: SKAction!
    var hurtAnimation: SKAction!
    var jumpAnimation: SKAction!
    var runAnimation: SKAction!
    var shootAnimation: SKAction!
    
    var lives: Int = 2
    var state: EntityState = .None
    
    init() {
        let defaulTexture = SKTexture(imageNamed: "idle-1")
        super.init(texture: defaulTexture, color: UIColor.clearColor(), size: defaulTexture.size())
        
    /*--------------------------------------SETUP ARCHER------------------------------------------------*/
        setupArcher()
        
    /*--------------------------------------RUN ANIMATION-----------------------------------------------*/
        var textures = [SKTexture]()
        textures = getTextures("run-", total: 14)
        
        let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        
        runAnimation = SKAction.repeatActionForever(animate)
        
    /*-------------------------------------JUMP ANIMATION-----------------------------------------------*/
        textures = getTextures("jump-", total: 8)
        jumpAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.075, resize: true, restore: false)
        
    /*-------------------------------------DEAD ANIMATION-----------------------------------------------*/
        textures = getTextures("dead-", total: 6)
        deadAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
    /*-------------------------------------SHOOT ANIMATION-----------------------------------------------*/
        textures = getTextures("shoot_straight-", total: 5)
        shootAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.025, resize: true, restore: false)
        
    /*-------------------------------------HURT ANIMATION-----------------------------------------------*/
        textures = getTextures("hurt-", total: 3)
        hurtAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupArcher() {
        position.x = 146
        position.y = 331
        
        createPhysicsBody()
    }
    
    func createPhysicsBody() {
        let archerPhysicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 26, height: 52), center: CGPoint(x: 0, y: -3))
        
        archerPhysicsBody.affectedByGravity = true
        archerPhysicsBody.usesPreciseCollisionDetection = true
        archerPhysicsBody.allowsRotation = false
        archerPhysicsBody.dynamic = true
        
        archerPhysicsBody.restitution = 0
        
        archerPhysicsBody.categoryBitMask = PhysicsCategory.Player
        archerPhysicsBody.collisionBitMask = PhysicsCategory.Floor
        archerPhysicsBody.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin | PhysicsCategory.IceBlock | PhysicsCategory.Heart
        
        self.physicsBody = archerPhysicsBody
    }
    
    
    func jump() {
        removeActionForKey("runForever")
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30)) //Phone
        
        runAction(jumpAnimation)
        
        if state != .Hurt {
            state = .Jumping
        }
        else {
            state = .HurtJump
        }
    }
    
    func doubleJump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        
        let doubleJumpAction = SKAction.rotateByAngle(-6.2830, duration: 0.25)
        runAction(doubleJumpAction)
        
        if state != .HurtJump {
            state = .DoubleJumping
        }
        else {
            state = .HurtDoubleJump
        }
    }
    
    func run() {
        runAction(runAnimation, withKey: "runForever")
        state = .Running
    }
    
    func hurt() {
        removeActionForKey("runForever")
        
        let waitForAnim = SKAction.waitForDuration(hurtAnimation.duration)
        
        let sequenceAnims = SKAction.sequence([hurtAnimation, waitForAnim, runAnimation])
        
        runAction(sequenceAnims)
    }
    
    func die() {
        if state == .Dead { return }
        
        physicsBody?.categoryBitMask = PhysicsCategory.None
        physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        removeActionForKey("runForever")
        removeAllActions()
        
        runAction(deadAnimation)
        
        state = .Dead
    }
    
    func shootArrowAnimation() {
        runAction(shootAnimation)
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
