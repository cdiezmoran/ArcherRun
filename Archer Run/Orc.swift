//
//  Orc.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/12/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class orc: SKSpriteNode {
    
    var deadAnimation: SKAction!
    var runAnimation: SKAction!
    var throwLeftAnimation: SKAction!
    var throwRightAnimation: SKAction!
    
/*-----------------------------------------------INIT-------------------------------------------------------------*/
    init() {
        let defaultTexture = SKTexture(imageNamed: "idleOrc-1")
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: defaultTexture.size())
        
    
        setupOrc()
        
        //RUN ANIMATION
        var textures = [SKTexture]()
        textures = getTextures("walkOrc-", total: 14)
        
        let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        
        runAnimation = SKAction.repeatActionForever(animate)
        
        //THROW-LEFT ANIMATION
        textures = getTextures("throw_left-", total: 8)
        throwLeftAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
        //THROW-RIGHT ANIMATION
        textures = getTextures("throw_right-", total: 8)
        throwRightAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
        //DEAD ANIMATION
        textures = getTextures("deadOrc-", total: 6)
        
        deadAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
    }
    
    
/*---------------------------------------------REQUIRED INIT------------------------------------------------------*/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
/*---------------------------------------------GET TEXTURES-------------------------------------------------------*/
    func getTextures(prefix: String, total: Int) -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for index in 1...total {
            let textureName = prefix + String(index)
            let texture = SKTexture(imageNamed: textureName)
            textures.append(texture)
        }
        
        return textures
    }
    
/*-----------------------------------------------SETUP ORC-------------------------------------------------------*/
    func setupOrc() {
        xScale = -1
        
        createPhysicsBody()
    }
    
/*-------------------------------------------CREATE PHYSICS BODY-------------------------------------------------*/
    func createPhysicsBody() {
        let orcPhysicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 36, height: 39), center: CGPoint(x: -4, y: -9))
        
        orcPhysicsBody.affectedByGravity = true
        orcPhysicsBody.usesPreciseCollisionDetection = true
        orcPhysicsBody.allowsRotation = false
        orcPhysicsBody.dynamic = true
        
        orcPhysicsBody.restitution = 0
        
        orcPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        orcPhysicsBody.collisionBitMask = PhysicsCategory.Floor
        orcPhysicsBody.contactTestBitMask = PhysicsCategory.Arrow
        
        physicsBody = orcPhysicsBody
    }
    
/*-----------------------------------------------RUN------------------------------------------------------------*/
    func run() {
        runAction(runAnimation, withKey: "runForever")
    }
    
    
/*-----------------------------------------------DEAD-----------------------------------------------------------*/
    func dead() {
        removeAllActions()
        
        runAction(deadAnimation)
    }
}
