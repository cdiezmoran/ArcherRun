//
//  WorldScrollExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/4/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func scrollStartingWorldElement(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollStartingWorldLayer(sprite: SKNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if startingScrollLayer.position.x <= -frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollSpriteInState(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -(sprite.size.width / 2) {
            sprite.position.x += sprite.size.width * 2
        }
        
        if sprite.name == "levelHolder1" || sprite.name == "levelHolder2" {
            if sprite.position.x <= sprite.size.width + sprite.size.width/2 {
                currentLevelHolder = sprite.name!
            }
        }
    }
    
    func scrollWorld(seconds: NSTimeInterval) {
        let secondsFloat = CGFloat(seconds)
        
        let scrollSpeed = (floorSpeed * 60) * secondsFloat
        let treesFrontSpeed = (2 * 60) * secondsFloat
        let treesBackSpeed = 60 * secondsFloat
        let mountainsSpeed = 30 * secondsFloat
        let enemyScrollSpeedSlow = ((floorSpeed + 3) * 60) * secondsFloat
        let enemyScrollSpeed = ((floorSpeed + 4) * 60) * secondsFloat
        let enemyScrollSpeedFast = ((floorSpeed + 5) * 60) * secondsFloat
        
        //Scroll rest of starting world
        scrollStartingWorldLayer(startingScrollLayer, speed: scrollSpeed)
        scrollStartingWorldElement(startTreesFront, speed: treesFrontSpeed)
        scrollStartingWorldElement(startTreesBack, speed: treesBackSpeed)
        scrollStartingWorldElement(startMountains, speed: mountainsSpeed)
        
        //Infinite Scroll
        scrollSpriteInState(levelHolder1, speed: scrollSpeed)
        scrollSpriteInState(levelHolder2, speed: scrollSpeed)
        scrollSpriteInState(mountains1, speed: mountainsSpeed)
        scrollSpriteInState(mountains2, speed: mountainsSpeed)
        scrollSpriteInState(treesBack1, speed: treesBackSpeed)
        scrollSpriteInState(treesBack2, speed: treesBackSpeed)
        scrollSpriteInState(treesFront1, speed: treesFrontSpeed)
        scrollSpriteInState(treesFront2, speed: treesFrontSpeed)
        
        obstacleScrollLayer.position.x -= scrollSpeed
        enemyScrollLayer.position.x -= enemyScrollSpeed
        enemyScrollLayerSlow.position.x -= enemyScrollSpeedSlow
        enemyScrollLayerFast.position.x -= enemyScrollSpeedFast
    }
    
    func removeObstacles() {
        for child in obstacleScrollLayer.children {
            let positionInScene = self.convertPoint(child.position, fromNode: obstacleScrollLayer)
            if positionInScene.x < -size.width / 3 {
                child.removeFromParent()
            }
        }
    }
}