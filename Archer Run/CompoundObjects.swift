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
    }
    
    func generateSpikesWithTarget() {
        let target = Target()
        let firstSpike = Spike()
        var spikes: [Spike] = []

        let targetX = scene.size.width + (firstSpike.size.width * 5) / 2
        let targetY = CGFloat.random(min: scene.size.height / 2, max: scene.size.height - 100)
        
        target.position = scene.convertPoint(CGPointMake(targetX, targetY), toNode: scene.obstacleScrollLayer)
        
        scene.obstacleScrollLayer.addChild(target)
        
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
