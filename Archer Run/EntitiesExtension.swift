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
                let index = arrows.index(of: arrow)!
                arrows.remove(at: index)
                arrow.removeFromParent()
            }
        }
    }
    
    func grabCoin(_ node: SKNode) {
        let coin = node as! Coin
        
        coin.removeFromParent()
        
        coinCount += 1
        
        playCoinGrabSound()
        
        ChallengeManager.sharedInstance.collectedCoin()
    }
    
    func killOrc(_ nodeOrc: SKNode, nodeArrow: SKNode) {
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
            explosion.position = orc.parent!.convert(orc.position, to: obstacleScrollLayer)
            obstacleScrollLayer.addChild(explosion)
            
            let wait = SKAction.wait(forDuration: 0.8)
            let removeExplosion = SKAction.run({ explosion.removeFromParent() })
            
            let sequence = SKAction.sequence([wait, removeExplosion])
            
            run(sequence)
            
            orc.die()
        }
        else {
            orc.die()
        }
        
        //Remove arrow from parent
        let removeArrow = SKAction.run({
            arrow.removeFromParent()
        })
        
        self.run(removeArrow)
        
        arrows.remove(at: arrows.index(of: arrow)!)
        
        let removeAndAddOrc = SKAction.run({
            orc.position = orc.parent!.convert(orc.position, to: self.obstacleScrollLayer)
            orc.removeFromParent()
            self.obstacleScrollLayer.addChild(orc)
        })
        
        self.run(removeAndAddOrc)
        
        playArrowHitSound()
        
        ChallengeManager.sharedInstance.killedOrc()
    }
    
    func hitTargetWithSpikes(_ node: SKNode, nodeArrow: SKNode) {
        let target = node as! Target
        let arrow = nodeArrow as! Arrow
        
        let removeArrow = SKAction.run({
            arrow.removeFromParent()
        })
        
        if arrow.type == .Ice {
            target.freeze()
            self.run(removeArrow)
        }
        
        for case let spike as Spike in target.children {
            let slideDown = SKAction.move(by: CGVector(dx: 0, dy: -spike.size.height), duration: 0.25)
            let removeSpike = SKAction.run({ spike.removeFromParent() })
            
            let slideAndRemove = SKAction.sequence([slideDown, removeSpike])
            
            spike.zPosition = -1
            spike.run(slideAndRemove)
        }
        
        target.gotHit()
        
        playArrowHitSound()
        
        ChallengeManager.sharedInstance.hitTarget()
    }
    
    func breakiceBlock(_ orcNode: SKNode) {
        let orc = orcNode as! Orc
        
        let particles = SKEmitterNode(fileNamed: "IceExplosion")!
        particles.position = orc.position
        
        let removeOrc = SKAction.run({ orc.removeFromParent() })
        let addParticles = SKAction.run({ self.obstacleScrollLayer.addChild(particles) })
        let wait = SKAction.wait(forDuration: 2.5)
        let removeParticles = SKAction.run({ particles.removeFromParent() })
        
        let sequence = SKAction.sequence([removeOrc, addParticles, wait, removeParticles])
                
        run(sequence)
    }
    
    func addHeart() {
        let heartTexture = SKTexture(imageNamed: "heartFinal")
        let newHeart = SKSpriteNode(texture: heartTexture, color: UIColor.clear, size: CGSize(width: 32, height: 32))
        if hearts.isEmpty {
            newHeart.position = CGPoint(x: 610, y: 380)
            hearts.append(newHeart)
            addChild(newHeart)
        }
        else {
            newHeart.position = hearts.last!.position + CGPoint(x: 38, y: 0)
            hearts.append(newHeart)
            addChild(newHeart)
        }
    }
    
    func grabHeart(_ heartNode: SKNode) {
        let heart = heartNode as! Heart
        
        let heartExplosion = SKEmitterNode(fileNamed: "HeartExplosion")!
        heartExplosion.position = heart.position
        
        let removeHeart = SKAction.run({ heart.removeFromParent() })
        let addParticles = SKAction.run({ self.obstacleScrollLayer.addChild(heartExplosion) })
        let wait = SKAction.wait(forDuration: 1.5)
        let removeParticles = SKAction.run({ heartExplosion.removeFromParent() })
        
        let sequence = SKAction.sequence([removeHeart, addParticles, wait, removeParticles])
        
        run(sequence)
        
        if archer.lives >= 2 {
            return
        }
        
        archer.lives += 1
        addHeart()
    }
    
    func hitUndead(_ arrowNode: SKNode) {
        if undead.state == .dead { return }
        
        let arrow = arrowNode as! Arrow
        undead.lives -= 1
        undeadHealthBar.xScale += 0.5
        
        arrow.physicsBody?.categoryBitMask = PhysicsCategory.None
        
        if undead.lives <= 0 {
            undead.die()
            ChallengeManager.sharedInstance.killedUndead()
        }
        else {
            //add hit anim
            let hitAnim = SKAction(named: "HurtFadeOnce")!
            undead.run(hitAnim)
        }
        
        let removeArrow = SKAction.run({
            arrow.removeFromParent()
        })
        
        self.run(removeArrow)
        
        playArrowHitSound()
    }
}
