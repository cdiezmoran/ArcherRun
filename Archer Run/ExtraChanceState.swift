//
//  ExtraChanceState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 9/1/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class ExtraChanceState: GKState {
    
    unowned let scene: GameScene
    
    var window: SKSpriteNode!
    var watchButton: MSButtonNode!
    var noThanksButton: MSButtonNode!
    var timeBar: SKSpriteNode!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnter(from previousState: GKState?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "removeAds"), object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ExtraChanceState.keepPlaying),
            name: NSNotification.Name(rawValue: "giveExtraChance"),
            object: nil)
        
        createUI()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExit(to nextState: GKState) {
        window.removeFromParent()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.keepEnemiesMoving(deltaTime: seconds)
    }
    
    func gameOver() {
        if scene.didCompleteChallenge {
            scene.gameState.enter(ChallengeCompletedState.self)
        }
        else {
            scene.gameState.enter(GameOverState.self)
        }
    }
    
    func keepPlaying() {
        scene.didGetExtraChance = true
        
        scene.archer.revive()
        scene.addHeart()
        scene.archer.run()
        scene.clearObstacles()
        
        scene.gameState.enter(PlayingState.self)
    }
    
    func createUI() {
        let blackAlpha = UIColor.black.withAlphaComponent(0.65)
        window = SKSpriteNode(color: blackAlpha, size: CGSize(width: scene.size.width, height: scene.size.height))
        window.zPosition = 100
        
        let firstLabel = SKLabelNode(fontNamed: "Menlo Regular")
        firstLabel.fontSize = 32
        firstLabel.text = "Watch video ad for"
        window.addChild(firstLabel)
        firstLabel.position = CGPoint(x: 0, y: 120)
        
        let secondLabel = firstLabel.copy() as! SKLabelNode
        secondLabel.text = "extra live"
        window.addChild(secondLabel)
        secondLabel.position = CGPoint(x: 0, y: 80)
        
        let heartTexture = SKTexture(imageNamed: "heartFinal")
        let heartSprite = SKSpriteNode(texture: heartTexture, color: UIColor.clear, size: heartTexture.size())
        window.addChild(heartSprite)
        
        let noThanksTexture = SKTexture(imageNamed: "noThanksButton")
        noThanksButton = MSButtonNode(texture: noThanksTexture, color: UIColor.clear, size: noThanksTexture.size())
        window.addChild(noThanksButton)
        noThanksButton.position = CGPoint(x: -118, y: -120)
        
        let watchTexture = SKTexture(imageNamed: "watchButton")
        watchButton = MSButtonNode(texture: watchTexture, color: UIColor.clear, size: watchTexture.size())
        window.addChild(watchButton)
        watchButton.position = CGPoint(x: 126, y: -120)
        
        setButtonHandlers()
        
        scene.addChild(window)
        window.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    }
    
    func setButtonHandlers() {
        watchButton.selectedHandler = {
            //Show video
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showRewardVideo"), object: nil)
        }
        noThanksButton.selectedHandler = {
            //End game
            self.gameOver()
        }
    }
}
