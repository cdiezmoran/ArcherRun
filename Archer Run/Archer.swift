//
//  Hero.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/2/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum EntityState {
    case None, Jumping, Running, Dead
}

class Archer: SKSpriteNode {
    
    var deadAnimation: SKAction!
    var jumpAnimation: SKAction!
    var runAnimation: SKAction!
    var state:EntityState = .None
    
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
        jumpAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
    /*-------------------------------------DEAD ANIMATION-----------------------------------------------*/
        textures = getTextures("dead-", total: 6)
        deadAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
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
        archerPhysicsBody.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin
        
        self.physicsBody = archerPhysicsBody
    }
    
    
    func jump() {
        removeActionForKey("runForever")
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30)) //Phone
        //physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60)) //Emulator
        
        runAction(jumpAnimation)
        state = .Jumping
    }
    
    
    func run() {
        runAction(runAnimation, withKey: "runForever")
        state = .Running
    }
    
    func die() {
        if state == .Dead { return }
        
        removeActionForKey("runForever")
        removeAllActions()
        
        runAction(deadAnimation)
        
        state = .Dead
    }
    
    func shootArrowAnimation() {
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
