//
//  Arrow.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/14/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum ArrowType: String {
    case Regular = "regular"
    case Explosive = "explosive"
    case Fire = "fire"
    case Ice = "ice"
}

class Arrow: SKSpriteNode {
    
    var type: ArrowType = .Regular
    
    var defaultTexture: SKTexture!
    let defaultSize = CGSize(width: 34.0, height: 8)
    
    init() {
        /*let userDefaults = NSUserDefaults.standardUserDefaults()
        let arrowRaw = userDefaults.stringForKey("arrowRawValue")!
        type = ArrowType(rawValue: arrowRaw)!*/
        
        switch type {
        case .Regular:
            //Use regular sprite
            defaultTexture = SKTexture(imageNamed: "arrow")
            break
        case .Explosive:
            //Use explosive sprite
            defaultTexture = SKTexture(imageNamed: "arrowExplosive")
            break
        case .Fire:
            //Use fire sprite
            defaultTexture = SKTexture(imageNamed: "arrowFire")
            break
        case .Ice:
            //Use ice sprite
            defaultTexture = SKTexture(imageNamed: "arrowIce")
            break
        }
        
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: defaultSize)
        
        if type == .Ice {
            addArrowParticles("IceTrail", advanceByTime: 0.6)
        }
        else if type == .Fire {
            addArrowParticles("FireTrail", advanceByTime: 0.6)
        }
        else if type == .Explosive {
            addArrowParticles("DynamiteTrail", advanceByTime: 0.2)
        }
        
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPhysicsBody() {
        let body = SKPhysicsBody(texture: defaultTexture, size: defaultSize)
        
        body.mass = 0.0037
        
        body.categoryBitMask = PhysicsCategory.Arrow
        body.collisionBitMask = PhysicsCategory.Target
        body.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Target
        
        physicsBody = body
    }
    
    func addArrowParticles(fileName: String, advanceByTime time: NSTimeInterval) {
        let particles = SKEmitterNode(fileNamed: fileName)!
        particles.advanceSimulationTime(time)
        addChild(particles)
    }
}
