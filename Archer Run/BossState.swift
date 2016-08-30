//
//  UndeadState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/3/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class BossState: GKState {
    
    unowned let scene: GameScene
    
    var arrowCount: Int = 0
    var checkPosition: CGPoint!
    var undeadArrowTimer: NSTimeInterval = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.undead = Undead()
        let x = scene.size.width + 10
        let minY = scene.levelHolder1.size.height + scene.undead.size.height
        let maxY = scene.size.height - scene.undead.size.height
        let y = CGFloat.random(min: minY, max: maxY)
        scene.undead.position = CGPointMake(x, y)
        createMagicPlatform()
        createHealthBar()
        checkPosition = scene.undead.position
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        var moveToAction: SKAction
        if scene.undead.state == .Dead {
            //moveToAction = SKAction.moveToY(-scene.size.height * 2, duration: 1)
            moveToAction = SKAction.moveTo(CGPoint(x: scene.size.width / 2, y: -scene.size.height * 2), duration: 1)
        }
        else {
            //moveToAction = SKAction.moveToY(scene.size.height * 2, duration: 1)
            moveToAction = SKAction.moveTo(CGPoint(x: 0, y: scene.size.height * 2), duration: 1)
        }
        
        let removeFromParent = SKAction.runBlock({ self.scene.undead.removeFromParent() })
        
        let sequence = SKAction.sequence([moveToAction, removeFromParent])
        
        undeadArrowTimer = 0
        arrowCount = 0
        
        scene.undead.runAction(sequence)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.score += scene.floorSpeed * CGFloat(seconds)
        
        if scene.undead.state == .Dead || arrowCount >= 2 {
            scene.gameState.enterState(PlayingState)
        }
        
        if !scene.undead.isPositioned {
            if scene.obstacleScrollLayer.children.count == 0 {
                scene.undead.position = scene.convertPoint(scene.undead.position, toNode: scene.obstacleScrollLayer)
                scene.obstacleScrollLayer.addChild(scene.undead)
                scene.undead.isMoving = true
            }
        }
        
        if scene.undead.isMoving {
            checkPosition = scene.convertPoint(scene.undead.position, fromNode: scene.obstacleScrollLayer)
        }
        
        if !scene.undead.isPositioned {
            if checkPosition.x <= (scene.size.width * 7) / 8 {
                scene.undead.position = scene.convertPoint(scene.undead.position, fromNode: scene.obstacleScrollLayer)
                scene.undead.removeFromParent()
                scene.addChild(scene.undead)
                
                scene.undead.isMoving = false
                scene.undead.isPositioned = true
            }
        }
        
        scene.scrollWorld(seconds)
        
        if scene.undead.isPositioned {
            undeadArrowTimer += scene.deltaTime
            if undeadArrowTimer >= 0.8 {
                //undead shoot arrow
                let swipe = CGVector(dx: scene.undead.position.x - scene.archer.position.x, dy: scene.undead.position.y - scene.archer.position.y)
                let mag = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
                
                let arrowDx = -swipe.dx / mag
                let arrowDy = -swipe.dy / mag
                
                scene.undead.shoot()
                
                let arrow = Arrow(isObstacle: true)
                scene.addChild(arrow)
                arrow.position = scene.undead.position //+ CGPoint(x: 10, y: -10)
                arrow.physicsBody?.applyImpulse(CGVector(dx: arrowDx * 8, dy: arrowDy * 5.5))
                arrowCount += 1
                
                undeadArrowTimer = 0
            }
        }
    }
    
    func createMagicPlatform() {
        let platformTexture = SKTexture(imageNamed: "magicPlatform")
        let platform = SKSpriteNode(texture: platformTexture, color: UIColor.clearColor(), size: CGSize(width: 100, height: 30))
        scene.undead.addChild(platform)
        platform.position = CGPoint(x: -10, y: -40)
        
        let particles = SKEmitterNode(fileNamed: "MagicPlatformTrail")!
        platform.addChild(particles)
    }
    
    func createHealthBar() {
        let healthBarSize = CGSize(width: 40, height: 5)
        let healthBarHolder = SKSpriteNode(color: UIColor.flatGrayColor(), size: healthBarSize)
        scene.undead.addChild(healthBarHolder)
        healthBarHolder.position = CGPoint(x: -7, y: 40)
        
        scene.undeadHealthBar = SKSpriteNode(color: UIColor.flatRedColor(), size: healthBarSize)
        scene.undeadHealthBar.anchorPoint.x = 0
        scene.undeadHealthBar.xScale = -1
        healthBarHolder.addChild(scene.undeadHealthBar)
        scene.undeadHealthBar.position.x = 20
    }
}