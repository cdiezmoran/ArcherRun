//
//  compoundObjects.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/18/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class CompoundObjects {
    
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func generateCoinBlock() {
        let coinNode = SKNode()
        let coinBlocks = [
                          [[1, 1, 1, 1, 1],
                           [1, 1, 1, 1, 1]],
                          
                          [[0, 0, 1, 0, 0, 0, 1, 0, 0],
                           [0, 1, 1, 1, 0, 1, 1, 1, 0],
                           [1, 1, 1, 1, 1, 1, 1, 1, 1],
                           [0, 1, 1, 1, 0, 1, 1, 1, 0],
                           [0, 0, 1, 0, 0, 0, 1, 0, 0]],
                          
                          [[0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1],
                           [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
                           [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]]
                         ]
        
        let randomIndex = Int(arc4random_uniform(3))
        let coinBlock = coinBlocks[randomIndex]
        
        var totalHeight: CGFloat = 0
        
        for row in 0 ..< coinBlock.count {
            let anotherCoin = Coin()
            totalHeight += anotherCoin.size.height
            for col in 0 ..< coinBlock[row].count {
                if coinBlock[row][col] == 1 {
                    let coin = Coin()
                    coinNode.addChild(coin)
                    coin.position.x = CGFloat(col) * coin.size.width
                    coin.position.y = CGFloat(-row) * coin.size.height
                }
            }
        }
        
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + totalHeight
        let newPosition = CGPoint(x: x, y: y)
        
        scene.obstacleScrollLayer.addChild(coinNode)
        coinNode.position = scene.convert(newPosition, to: scene.obstacleScrollLayer)
        coinNode.zPosition = 50
    }
    
    func generateSpikesWithTarget() {
        let target = Target()
        let firstSpike = Spike()
        var spikes: [Spike] = []
        var chainLinks: [SKSpriteNode] = []

        /*-----------------------------SETUP TARGET-----------------------------------------------*/
        let targetX = scene.size.width + (firstSpike.size.width * 5) / 2
        let targetY = CGFloat.random(min: scene.size.height / 2, max: scene.size.height - 100)
        
        let targetPosition = CGPoint(x: targetX, y: targetY)
        
        target.position = scene.convert(targetPosition, to: scene.obstacleScrollLayer)
        scene.obstacleScrollLayer.addChild(target)
        
        /*-----------------------------SETUP CHAIN-----------------------------------------------*/
        let numberOfLinks = round((scene.size.height - targetPosition.y) / 30) + 1
        var linkPos = target.position
        
        for _ in 0..<Int(numberOfLinks) {
            let texture = SKTexture(imageNamed: "chain")
            let chainLink = SKSpriteNode(texture: texture, color: UIColor.clear, size: texture.size())
            
            chainLink.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
            
            //chainLink.physicsBody?.mass *= 0.5
            
            chainLink.physicsBody?.categoryBitMask = PhysicsCategory.None
            chainLink.physicsBody?.collisionBitMask = PhysicsCategory.None
            chainLink.physicsBody?.contactTestBitMask = PhysicsCategory.None
            
            chainLink.position = linkPos
            linkPos.y += texture.size().height
            
            chainLink.zPosition = -1
            
            scene.obstacleScrollLayer.addChild(chainLink)
            chainLinks.append(chainLink)
        }
        
        for i in 0..<chainLinks.count {
            if i == 0 {
                let position = scene.convert(target.position, from: scene.obstacleScrollLayer)
                let pin = SKPhysicsJointPin.joint(withBodyA: target.physicsBody!, bodyB: chainLinks[i].physicsBody!, anchor: position)
                scene.physicsWorld.add(pin)
            }
            else {
                var anchor = scene.convert(chainLinks[i].position, from: scene.obstacleScrollLayer)
                anchor.y -= 15
                let pin = SKPhysicsJointPin.joint(withBodyA: chainLinks[i-1].physicsBody!, bodyB: chainLinks[i].physicsBody!, anchor: anchor)
                scene.physicsWorld.add(pin)
            }
        }
        
        let lastLink = chainLinks.last!
        
        let topNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 50, height: 50))
        
        topNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        topNode.physicsBody?.affectedByGravity = false
        topNode.physicsBody?.isDynamic = false
        topNode.physicsBody?.allowsRotation = false
        
        topNode.physicsBody?.categoryBitMask = PhysicsCategory.None
        topNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        topNode.position = lastLink.position
        scene.obstacleScrollLayer.addChild(topNode)
        
        let lastPinPosition = scene.convert(topNode.position, from: scene.obstacleScrollLayer)
        let lastPin = SKPhysicsJointPin.joint(withBodyA: topNode.physicsBody!, bodyB: lastLink.physicsBody!, anchor: lastPinPosition)
        scene.physicsWorld.add(lastPin)
        
        /*-----------------------------SETUP SPIKES-----------------------------------------------*/
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + firstSpike.size.height / 2
        firstSpike.position = scene.convert(CGPoint(x: x, y: y), to: target)
        
        target.addChild(firstSpike)
        spikes.append(firstSpike)
        
        for index in 1...4 {
            let newSpike = Spike()
            newSpike.position.x = spikes[index-1].position.x + newSpike.size.width
            newSpike.position.y = spikes[index-1].position.y
            
            target.addChild(newSpike)
            spikes.append(newSpike)
        }
    }
}
