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
        let newPosition = CGPointMake(x, y)
        
        scene.obstacleScrollLayer.addChild(coinNode)
        coinNode.position = scene.convertPoint(newPosition, toNode: scene.obstacleScrollLayer)
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
        
        let targetPosition = CGPointMake(targetX, targetY)
        
        target.position = scene.convertPoint(targetPosition, toNode: scene.obstacleScrollLayer)
        scene.obstacleScrollLayer.addChild(target)
        
        /*-----------------------------SETUP CHAIN-----------------------------------------------*/
        let numberOfLinks = round((scene.size.height - targetPosition.y) / 30) + 1
        var linkPos = target.position
        
        for _ in 0..<Int(numberOfLinks) {
            let texture = SKTexture(imageNamed: "chain")
            let chainLink = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texture.size())
            
            chainLink.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
            
            chainLink.physicsBody?.mass *= 0.5
            
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
                let position = scene.convertPoint(target.position, fromNode: scene.obstacleScrollLayer)
                let pin = SKPhysicsJointPin.jointWithBodyA(target.physicsBody!, bodyB: chainLinks[i].physicsBody!, anchor: position)
                scene.physicsWorld.addJoint(pin)
            }
            else {
                var anchor = scene.convertPoint(chainLinks[i].position, fromNode: scene.obstacleScrollLayer)
                anchor.y -= 15
                let pin = SKPhysicsJointPin.jointWithBodyA(chainLinks[i-1].physicsBody!, bodyB: chainLinks[i].physicsBody!, anchor: anchor)
                scene.physicsWorld.addJoint(pin)
            }
        }
        
        let lastLink = chainLinks.last!
        
        let topNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 50, height: 50))
        
        topNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50, height: 50))
        topNode.physicsBody?.affectedByGravity = false
        topNode.physicsBody?.dynamic = false
        topNode.physicsBody?.allowsRotation = false
        
        topNode.physicsBody?.categoryBitMask = PhysicsCategory.None
        topNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        topNode.position = lastLink.position
        scene.obstacleScrollLayer.addChild(topNode)
        
        let lastPinPosition = scene.convertPoint(topNode.position, fromNode: scene.obstacleScrollLayer)
        let lastPin = SKPhysicsJointPin.jointWithBodyA(topNode.physicsBody!, bodyB: lastLink.physicsBody!, anchor: lastPinPosition)
        scene.physicsWorld.addJoint(lastPin)
        
        /*-----------------------------SETUP SPIKES-----------------------------------------------*/
        let x = scene.size.width + 10
        let y = scene.levelHolder1.size.height + firstSpike.size.height / 2
        firstSpike.position = scene.convertPoint(CGPointMake(x, y), toNode: target)
        
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
