//
//  EntitiesExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/5/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    func checkForArrowOutOfBounds() {
        for arrow in arrows {
            if arrow.position.y < 0 || arrow.position.x < 0{
                let index = arrows.indexOf(arrow)!
                arrows.removeAtIndex(index)
                arrow.removeFromParent()
            }
        }
    }
    
    func grabCoin(node: SKNode) {
        let coin = node as! Coin
        
        coin.removeFromParent()
        
        coinCount += 1
        
        playCoinGrabSound()
        
        ChallengeManager.sharedInstance.collectedCoin()
    }
    
    func killOrc(nodeOrc: SKNode, nodeArrow: SKNode) {
        let orc = nodeOrc as! MeleeOrc
        let arrow = nodeArrow as! Arrow
        
        if arrow.type == .Ice {
            orc.freeze()
        }
        else if arrow.type == .Fire {
            orc.die()
            orc.burn()
        }
        else if arrow.type == .Explosive {
            orc.physicsBody!.applyImpulse(CGVector(dx: 30, dy: 30))
            
            
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.zPosition = orc.zPosition + 1
            explosion.position = orc.parent!.convertPoint(orc.position, toNode: obstacleScrollLayer)
            obstacleScrollLayer.addChild(explosion)
            
            let wait = SKAction.waitForDuration(0.8)
            let removeExplosion = SKAction.runBlock({ explosion.removeFromParent() })
            
            let sequence = SKAction.sequence([wait, removeExplosion])
            
            runAction(sequence)
            
            orc.die()
        }
        else {
            orc.die()
        }
        
        //Remove arrow from parent
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        self.runAction(removeArrow)
        
        arrows.removeAtIndex(arrows.indexOf(arrow)!)
        
        let removeAndAddOrc = SKAction.runBlock({
            orc.position = orc.parent!.convertPoint(orc.position, toNode: self.obstacleScrollLayer)
            orc.removeFromParent()
            self.obstacleScrollLayer.addChild(orc)
        })
        
        self.runAction(removeAndAddOrc)
        
        playArrowHitSound()
        
        ChallengeManager.sharedInstance.killedOrc()
    }
    
    func hitTargetWithSpikes(node: SKNode, nodeArrow: SKNode) {
        let target = node as! Target
        let arrow = nodeArrow as! Arrow
        
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        if arrow.type == .Ice {
            target.freeze()
            self.runAction(removeArrow)
        }
        
        for case let spike as Spike in target.children {
            let slideDown = SKAction.moveBy(CGVector(dx: 0, dy: -spike.size.height), duration: 0.25)
            let removeSpike = SKAction.runBlock({ spike.removeFromParent() })
            
            let slideAndRemove = SKAction.sequence([slideDown, removeSpike])
            
            spike.zPosition = -1
            spike.runAction(slideAndRemove)
        }
        
        target.gotHit()
        
        playArrowHitSound()
        
        ChallengeManager.sharedInstance.hitTarget()
    }
    
    func breakiceBlock(orcNode: SKNode) {
        let orc = orcNode as! Orc
        
        let particles = SKEmitterNode(fileNamed: "IceExplosion")!
        particles.position = orc.position
        
        let removeOrc = SKAction.runBlock({ orc.removeFromParent() })
        let addParticles = SKAction.runBlock({ self.obstacleScrollLayer.addChild(particles) })
        let wait = SKAction.waitForDuration(2.5)
        let removeParticles = SKAction.runBlock({ particles.removeFromParent() })
        
        let sequence = SKAction.sequence([removeOrc, addParticles, wait, removeParticles])
                
        runAction(sequence)
    }
    
    func addHeart() {
        let heartTexture = SKTexture(imageNamed: "heartFinal")
        let newHeart = SKSpriteNode(texture: heartTexture, color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
        if hearts.isEmpty {
            newHeart.position = CGPointMake(622, 380)
            hearts.append(newHeart)
            addChild(newHeart)
        }
        else {
            newHeart.position = hearts.last!.position + CGPoint(x: 38, y: 0)
            hearts.append(newHeart)
            addChild(newHeart)
        }
    }
    
    func grabHeart(heartNode: SKNode) {
        let heart = heartNode as! Heart
        
        let heartExplosion = SKEmitterNode(fileNamed: "HeartExplosion")!
        heartExplosion.position = heart.position
        
        let removeHeart = SKAction.runBlock({ heart.removeFromParent() })
        let addParticles = SKAction.runBlock({ self.obstacleScrollLayer.addChild(heartExplosion) })
        let wait = SKAction.waitForDuration(1.5)
        let removeParticles = SKAction.runBlock({ heartExplosion.removeFromParent() })
        
        let sequence = SKAction.sequence([removeHeart, addParticles, wait, removeParticles])
        
        runAction(sequence)
        
        if archer.lives >= 2 {
            return
        }
        
        archer.lives += 1
        addHeart()
    }
    
    func hitUndead(arrowNode: SKNode) {
        let arrow = arrowNode as! Arrow
        undead.lives -= 1
        
        arrow.physicsBody?.categoryBitMask = PhysicsCategory.None
        
        if undead.lives <= 0 {
            undead.die()
            ChallengeManager.sharedInstance.killedUndead()
        }
        else {
            //add hit anim
            let hitAnim = SKAction(named: "HurtFadeOnce")!
            undead.runAction(hitAnim)
        }
        
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        self.runAction(removeArrow)
        
        playArrowHitSound()
    }
}
