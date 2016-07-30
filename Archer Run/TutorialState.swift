//
//  TutorialState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/21/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    
    unowned let scene: GameScene
    
    var separator: SKSpriteNode!
    var tapLabel: SKLabelNode!
    var dragLabel: SKLabelNode!
    var tapSideWidth: CGFloat!
    var dragSideWidth: CGFloat!
    
    var correctBox: SKSpriteNode!
    
    var addedCorrectIndicator: Bool = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        /*
         * Drag functionality was changed to tap have not changed var names yet
         * (Yes i'm way too lazy)
         */
        
        tapSideWidth = (scene.size.width / 2) / 2
        dragSideWidth = scene.size.width - tapSideWidth
        
        let gray = UIColor.grayColor()
        let alphaGray = gray.colorWithAlphaComponent(0.3)
        
        separator = SKSpriteNode(color: alphaGray, size: CGSize(width: 1.5, height: scene.size.height))
        separator.position.x = tapSideWidth
        separator.position.y = scene.size.height / 2
        separator.zPosition = 20
        scene.addChild(separator)
        
        tapLabel = SKLabelNode(fontNamed: "Arial")
        dragLabel = SKLabelNode(fontNamed: "Arial")
        
        tapLabel.text = "Tap to Jump"
        dragLabel.text = "Tap to shoot"
        
        tapLabel.position.x = tapSideWidth / 2
        tapLabel.position.y = scene.size.height / 2
        
        dragLabel.position.x = (dragSideWidth / 2) + tapSideWidth
        dragLabel.position.y = scene.size.height / 2
        
        let fadeAction = SKAction.fadeAlphaBy(0.3, duration: 0.5)
        let fadeAnimation = SKAction.repeatActionForever(fadeAction)
        
        tapLabel.runAction(fadeAnimation)
        dragLabel.runAction(fadeAnimation)
        
        scene.addChild(tapLabel)
        scene.addChild(dragLabel)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
       return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        if !addedCorrectIndicator {
            if scene.didTutJump {
                addCorrectIndicator(tapLabel, sideWidth: tapSideWidth)
            }
            
            if scene.didTutShoot {
                addCorrectIndicator(dragLabel, sideWidth: dragSideWidth)
            }
        }
        
        if scene.didTutShoot && scene.didTutJump {
            separator.removeFromParent()
            tapLabel.removeFromParent()
            dragLabel.removeFromParent()
            correctBox.removeFromParent()
            
            scene.gameState.enterState(PlayingState)
        }
        
        let floorSpeed: CGFloat = 4
        
        let secondsFloat = CGFloat(seconds)
        
        let scrollSpeed = (floorSpeed * 60) * secondsFloat
        let treesFrontSpeed = (2 * 60) * secondsFloat
        let treesBackSpeed = 60 * secondsFloat
        let mountainsSpeed = 30 * secondsFloat
        let enemyScrollSpeed = ((floorSpeed + 2) * 60) * secondsFloat
        
        //Scroll rest of starting world
        scrollStartingWorldLayer(scene.startingScrollLayer, speed: scrollSpeed)
        scrollStartingWorldElement(scene.startTreesFront, speed: treesFrontSpeed)
        scrollStartingWorldElement(scene.startTreesBack, speed: treesBackSpeed)
        scrollStartingWorldElement(scene.startMountains, speed: mountainsSpeed)
        
        //Infinite Scroll
        scrollSprite(scene.levelHolder1, speed: scrollSpeed)
        scrollSprite(scene.levelHolder2, speed: scrollSpeed)
        scrollSprite(scene.mountains1, speed: mountainsSpeed)
        scrollSprite(scene.mountains2, speed: mountainsSpeed)
        scrollSprite(scene.treesBack1, speed: treesBackSpeed)
        scrollSprite(scene.treesBack2, speed: treesBackSpeed)
        scrollSprite(scene.treesFront1, speed: treesFrontSpeed)
        scrollSprite(scene.treesFront2, speed: treesFrontSpeed)
        
        scene.obstacleScrollLayer.position.x -= scrollSpeed
        scene.enemyScrollLayer.position.x -= enemyScrollSpeed
    }
    
    func scrollStartingWorldElement(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollStartingWorldLayer(sprite: SKNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if scene.startingScrollLayer.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -(sprite.size.width / 2) {
            sprite.position.x += sprite.size.width * 2
        }
        
        if sprite.name == "levelHolder1" || sprite.name == "levelHolder2" {
            if sprite.position.x <= sprite.size.width + sprite.size.width/2 {
                scene.currentLevelHolder = sprite.name!
            }
        }
    }
    
    func addCorrectIndicator(label: SKLabelNode, sideWidth: CGFloat) {
        let greenColor = UIColor.greenColor()
        let alphaGreen = greenColor.colorWithAlphaComponent(0.5)
        
        correctBox = SKSpriteNode(color: alphaGreen, size: CGSize(width: sideWidth, height: scene.size.height))
        
        let completedTexture = SKTexture(imageNamed: "completed")
        let completedIcon = SKSpriteNode(texture: completedTexture, color: UIColor.clearColor(), size: completedTexture.size())
        correctBox.addChild(completedIcon)
        completedIcon.position.x = 0
        completedIcon.position.y = 0
        
        scene.addChild(correctBox)
        correctBox.position.x = label.position.x
        correctBox.position.y = label.position.y
        correctBox.zPosition = 10
        
        label.hidden = true
        
        addedCorrectIndicator = true
    }
}
