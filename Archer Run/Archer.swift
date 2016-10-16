//
//  Hero.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/2/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum EntityState {
    case none, jumping, running, dead, doubleJumping, hurt, hurtJump, hurtDoubleJump
}

enum ArcherType: String {
    case Archer = "archer"
    case Angel = "angel"
}

class Archer: SKSpriteNode {
    
    var deadAnimation: SKAction!
    var hurtAnimation: SKAction!
    var jumpAnimation: SKAction!
    var runAnimation: SKAction!
    var runAnimationOnce: SKAction!
    var shootAnimation: SKAction!
    
    var runName: String = "run-"
    var runCount: Int = 14
    var jumpName: String = "jump-"
    var jumpCount: Int = 8
    var deadName: String = "dead-"
    var deadCount: Int = 6
    var shootName: String = "shoot_straight-"
    var shootCount: Int = 5
    var hurtName: String = "hurt-"
    var hurtCount: Int = 3
    
    var lives: Int = 2
    var state: EntityState = .none
    var type: ArcherType = .Archer
    
    init() {
        let defaulTexture = SKTexture(imageNamed: "idle-1")
        super.init(texture: defaulTexture, color: UIColor.clear, size: defaulTexture.size())
        
    /*--------------------------------------SETUP ARCHER------------------------------------------------*/
        setupArcher()
        getArcherType()
        getValuesForAnimations()
        
    /*--------------------------------------RUN ANIMATION-----------------------------------------------*/
        var textures = [SKTexture]()
        textures = getTextures(runName, total: runCount)
        
        runAnimationOnce = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        
        runAnimation = SKAction.repeatForever(runAnimationOnce)
        
    /*-------------------------------------JUMP ANIMATION-----------------------------------------------*/
        textures = getTextures(jumpName, total: jumpCount)
        jumpAnimation = SKAction.animate(with: textures, timePerFrame: 0.075, resize: true, restore: false)
        
    /*-------------------------------------DEAD ANIMATION-----------------------------------------------*/
        textures = getTextures(deadName, total: deadCount)
        deadAnimation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: false)
        
    /*-------------------------------------SHOOT ANIMATION-----------------------------------------------*/
        textures = getTextures(shootName, total: shootCount)
        shootAnimation = SKAction.animate(with: textures, timePerFrame: 0.025, resize: true, restore: false)
        
    /*-------------------------------------HURT ANIMATION-----------------------------------------------*/
        textures = getTextures(hurtName, total: hurtCount)
        hurtAnimation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupArcher() {
        position.x = 146
        position.y = 334
        
        createPhysicsBody()
    }
    
    func createPhysicsBody() {
        let archerPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 26, height: 52), center: CGPoint(x: 0, y: -3))
        
        archerPhysicsBody.affectedByGravity = true
        archerPhysicsBody.usesPreciseCollisionDetection = true
        archerPhysicsBody.allowsRotation = false
        archerPhysicsBody.isDynamic = true
        
        archerPhysicsBody.restitution = 0
        
        archerPhysicsBody.categoryBitMask = PhysicsCategory.Player
        archerPhysicsBody.collisionBitMask = PhysicsCategory.Floor
        archerPhysicsBody.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin | PhysicsCategory.IceBlock | PhysicsCategory.Heart
        
        self.physicsBody = archerPhysicsBody
    }
    
    
    func jump() {
        removeAction(forKey: "runForever")
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30)) //Phone
        
        self.run(jumpAnimation)
        
        if state != .hurt {
            state = .jumping
        }
        else {
            state = .hurtJump
        }
    }
    
    func doubleJump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        
        let doubleJumpAction = SKAction.rotate(byAngle: -6.2830, duration: 0.25)
        self.run(doubleJumpAction, withKey: "doubleJump")
        
        if state != .hurtJump {
            state = .doubleJumping
        }
        else {
            state = .hurtDoubleJump
        }
    }
    
    func run() {
        self.run(runAnimation, withKey: "runForever")
        state = .running
    }
    
    func hurt() {
        removeAction(forKey: "runForever")
        
        let waitForAnim = SKAction.wait(forDuration: hurtAnimation.duration)
        
        let sequenceAnims = SKAction.sequence([hurtAnimation, waitForAnim, runAnimationOnce])
        
        self.run(sequenceAnims)
    }
    
    func die() {
        if state == .dead { return }
        
        physicsBody?.categoryBitMask = PhysicsCategory.None
        physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        removeAllActions()
        
        self.run(deadAnimation)
        
        state = .dead
    }
    
    func shootArrowAnimation() {
        self.run(shootAnimation)
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
    
    func resetRotation() {
        removeAllActions()
        let resetRotation = SKAction.rotate(toAngle: 6.2830, duration: 0)
        self.run(resetRotation)
    }
    
    func doRunAnimation() {
        self.run(runAnimation, withKey: "runForever")
    }
    
    func revive() {
        lives += 1
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin | PhysicsCategory.IceBlock | PhysicsCategory.Heart
    }
    
    func getValuesForAnimations() {
        switch type {
        case .Angel:
            setNamePrefix("angel-")
            
            runCount = 10
            jumpCount = 10
            deadCount = 10
            shootCount = 10
            hurtCount = 10
            break
        default:
            break
        }
    }
    
    func setNamePrefix(_ prefix: String) {
        runName = prefix + runName
        jumpName = prefix + jumpName
        deadName = prefix + deadName
        shootName = prefix + shootName
        hurtName = prefix + hurtName
    }
    
    func getArcherType() {
        let userDefaults = UserDefaults.standard
        if let arrowRaw = userDefaults.string(forKey: "archerRawValue") {
            self.type = ArcherType(rawValue: arrowRaw)!
        }
        else {
            type = .Archer
            userDefaults.set(type.rawValue, forKey: "archerRawValue")
            userDefaults.synchronize()
        }
    }
}
