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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ExtraChanceState.keepPlaying),
            name: "giveExtraChance",
            object: nil)
        
        createUI()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        window.removeFromParent()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    func gameOver() {
        if scene.didCompleteChallenge {
            scene.gameState.enterState(ChallengeCompletedState)
        }
        else {
            scene.gameState.enterState(GameOverState)
        }
    }
    
    func keepPlaying() {
        scene.didGetExtraChance = true
        
        scene.archer.revive()
        scene.addHeart()
        scene.archer.run()
        scene.clearObstacles()
        
        scene.gameState.enterState(PlayingState)
    }
    
    func createUI() {
        let blackAlpha = UIColor.blackColor().colorWithAlphaComponent(0.65)
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
        let heartSprite = SKSpriteNode(texture: heartTexture, color: UIColor.clearColor(), size: heartTexture.size())
        window.addChild(heartSprite)
        
        let noThanksTexture = SKTexture(imageNamed: "noThanksButton")
        noThanksButton = MSButtonNode(texture: noThanksTexture, color: UIColor.clearColor(), size: noThanksTexture.size())
        window.addChild(noThanksButton)
        noThanksButton.position = CGPoint(x: -118, y: -120)
        
        let watchTexture = SKTexture(imageNamed: "watchButton")
        watchButton = MSButtonNode(texture: watchTexture, color: UIColor.clearColor(), size: watchTexture.size())
        window.addChild(watchButton)
        watchButton.position = CGPoint(x: 126, y: -120)
        
        setButtonHandlers()
        
        scene.addChild(window)
        window.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    }
    
    func setButtonHandlers() {
        watchButton.selectedHandler = {
            //Show video
            NSNotificationCenter.defaultCenter().postNotificationName("showRewardVideo", object: nil)
        }
        noThanksButton.selectedHandler = {
            //End game
            self.gameOver()
        }
    }
}
