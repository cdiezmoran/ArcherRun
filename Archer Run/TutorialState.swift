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
    
    override func didEnter(from previousState: GKState?) {
        /*
         * Drag functionality was changed to tap have not changed var names yet
         * (Yes i'm way too lazy)
         */
        
        tapSideWidth = (scene.size.width / 2) / 2
        dragSideWidth = scene.size.width - tapSideWidth
        
        let white = UIColor.white
        let alphaWhite = white.withAlphaComponent(0.3)
        
        separator = SKSpriteNode(color: alphaWhite, size: CGSize(width: 1.5, height: scene.size.height))
        separator.position.x = tapSideWidth
        separator.position.y = scene.size.height / 2
        separator.zPosition = 20
        scene.addChild(separator)
        
        tapLabel = SKLabelNode(fontNamed: "Arial")
        dragLabel = SKLabelNode(fontNamed: "Arial")
        
        tapLabel.text = "Tap to Jump"
        dragLabel.text = "Tap to Shoot"
        
        let extraLabel = SKLabelNode(fontNamed: "Arial")
        extraLabel.text = "(location matters!)"
        dragLabel.addChild(extraLabel)
        extraLabel.position += CGPoint(x: 0, y: -dragLabel.fontSize)
        
        tapLabel.position.x = tapSideWidth / 2
        tapLabel.position.y = scene.size.height / 2
        
        dragLabel.position.x = (dragSideWidth / 2) + tapSideWidth
        dragLabel.position.y = scene.size.height / 2
        
        let fadeAction = SKAction.fadeAlpha(by: 0.3, duration: 0.5)
        let fadeAnimation = SKAction.repeatForever(fadeAction)
        
        tapLabel.run(fadeAnimation)
        dragLabel.run(fadeAnimation)
        
        scene.addChild(tapLabel)
        scene.addChild(dragLabel)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
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
            
            scene.gameState.enter(PlayingState.self)
        }
        
        let floorSpeed: CGFloat = 4
        
        let secondsFloat = CGFloat(seconds)
        
        let scrollSpeed = (floorSpeed * 60) * secondsFloat
        let treesFrontSpeed = (2 * 60) * secondsFloat
        let treesBackSpeed = 60 * secondsFloat
        let mountainsSpeed = 30 * secondsFloat
        
        //Scroll rest of starting world
        scene.scrollStartingWorldLayer(scene.startingScrollLayer, speed: scrollSpeed)
        scene.scrollStartingWorldElement(scene.startTreesFront, speed: treesFrontSpeed)
        scene.scrollStartingWorldElement(scene.startTreesBack, speed: treesBackSpeed)
        scene.scrollStartingWorldElement(scene.startMountains, speed: mountainsSpeed)
        
        //Infinite Scroll
        scene.scrollSpriteInState(scene.levelHolder1, speed: scrollSpeed)
        scene.scrollSpriteInState(scene.levelHolder2, speed: scrollSpeed)
        scene.scrollSpriteInState(scene.mountains1, speed: mountainsSpeed)
        scene.scrollSpriteInState(scene.mountains2, speed: mountainsSpeed)
        scene.scrollSpriteInState(scene.treesBack1, speed: treesBackSpeed)
        scene.scrollSpriteInState(scene.treesBack2, speed: treesBackSpeed)
        scene.scrollSpriteInState(scene.treesFront1, speed: treesFrontSpeed)
        scene.scrollSpriteInState(scene.treesFront2, speed: treesFrontSpeed)
    }
    
    func addCorrectIndicator(_ label: SKLabelNode, sideWidth: CGFloat) {
        let greenColor = UIColor.green
        let alphaGreen = greenColor.withAlphaComponent(0.5)
        
        correctBox = SKSpriteNode(color: alphaGreen, size: CGSize(width: sideWidth, height: scene.size.height))
        
        let completedTexture = SKTexture(imageNamed: "completed")
        let completedIcon = SKSpriteNode(texture: completedTexture, color: UIColor.clear, size: completedTexture.size())
        correctBox.addChild(completedIcon)
        completedIcon.position.x = 0
        completedIcon.position.y = 0
        
        scene.addChild(correctBox)
        correctBox.position.x = label.position.x
        correctBox.position.y = label.position.y
        correctBox.zPosition = 10
        
        label.isHidden = true
        
        addedCorrectIndicator = true
    }
}
