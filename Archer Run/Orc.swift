//
//  Orc.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/12/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Orc: SKSpriteNode {
    
    var deadAnimation: SKAction!
    var throwAnimation: SKAction!
    var state: EntityState = .none
    var bodySize = CGSize(width: 36, height: 48)
    var bodyPosition = CGPoint(x: -2.5, y: -4.5)
    
/*-----------------------------------------------INIT-------------------------------------------------------------*/
    init() {
        let defaultTexture = SKTexture(imageNamed: "idleOrc-1")
        super.init(texture: defaultTexture, color: UIColor.clear, size: defaultTexture.size())
        
        xScale = -1
        createPhysicsBody()
        
        var textures = [SKTexture]()
        
        //DEAD ANIMATION
        textures = getTextures("deadOrc-", total: 6)
        
        deadAnimation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: false)
        
        //THROW ANIMATION
        textures = getTextures("throw_left-", total: 8)
        
        throwAnimation = SKAction.animate(with: textures, timePerFrame: 0.01, resize: true, restore: false)
    }
    
    
/*---------------------------------------------REQUIRED INIT------------------------------------------------------*/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
/*---------------------------------------------GET TEXTURES-------------------------------------------------------*/
    func getTextures(_ prefix: String, total: Int) -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for index in 1...total {
            let textureName = prefix + String(index)
            let texture = SKTexture(imageNamed: textureName)
            textures.append(texture)
        }
        
        return textures
    }
    
/*-------------------------------------------CREATE PHYSICS BODY-------------------------------------------------*/
    func createPhysicsBody() {
        let orcPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 36, height: 48), center: CGPoint(x: -2.5, y: -4.5))
        
        orcPhysicsBody.affectedByGravity = true
        orcPhysicsBody.usesPreciseCollisionDetection = true
        orcPhysicsBody.allowsRotation = false
        orcPhysicsBody.isDynamic = true
        
        orcPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        orcPhysicsBody.collisionBitMask = PhysicsCategory.Floor
        orcPhysicsBody.contactTestBitMask = PhysicsCategory.Arrow
        
        physicsBody = orcPhysicsBody
    }
    
/*-----------------------------------------------DEAD-----------------------------------------------------------*/
    func die() {
        removeAllActions()
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        
        run(deadAnimation)
    }
    
    func freeze() {
        removeAllActions()
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.IceBlock
        
        let iceBlock = SKSpriteNode(texture: SKTexture(imageNamed: "iceBlockAlt"), color: UIColor.clear, size: bodySize)
        iceBlock.alpha = 0.5
        iceBlock.zPosition = self.zPosition + 1
        addChild(iceBlock)
        iceBlock.position = bodyPosition
    }
    
    func burn() {
        let fire = SKEmitterNode(fileNamed: "Fire")!
        fire.zPosition = self.zPosition + 1
        addChild(fire)
        fire.position.y -= self.size.height / 2
    }
}
