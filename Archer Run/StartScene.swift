//
//  StartScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var water: SKSpriteNode!
    var water2: SKSpriteNode!
    var clouds: SKEmitterNode!
    var musicOn: MSButtonNode!
    var musicOff: MSButtonNode!
    var soundsOn: MSButtonNode!
    var soundsOff: MSButtonNode!
    
    var backgroundMusic: SKAudioNode!
    
    let fixedDelta: CFTimeInterval = 1.0/60.0
    let scrollSpeed: CGFloat = 160
    
    override func didMoveToView(view: SKView) {
        water = self.childNodeWithName("water") as! SKSpriteNode
        water2 = self.childNodeWithName("water2") as! SKSpriteNode
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        musicOn = self.childNodeWithName("musicOn") as! MSButtonNode
        musicOff = self.childNodeWithName("musicOff") as! MSButtonNode
        soundsOn = self.childNodeWithName("soundsOn") as! MSButtonNode
        soundsOff = self.childNodeWithName("soundsOff") as! MSButtonNode
        
        clouds.advanceSimulationTime(100)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let musicIsOn = userDefaults.boolForKey("musicSettings")
        let soundsAreOn = userDefaults.boolForKey("soundsSettings")
        
        if musicIsOn {
            musicOff.hidden = true
            playBackgroundMusic()
        }
        else {
            musicOn.hidden = true
        }
        
        if soundsAreOn {
            soundsOff.hidden = true
        }
        else {
            soundsOn.hidden = true
        }
        
        musicOn.selectedHandler = {
            //Turn music off
            self.musicOn.hidden = true
            self.musicOff.hidden = false
            
            if let music = self.backgroundMusic {
                music.removeFromParent()
            }
            
            userDefaults.setBool(false, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.hidden = false
            self.musicOff.hidden = true
            
            self.playBackgroundMusic()
            
            userDefaults.setBool(true, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.hidden = true
            self.soundsOff.hidden = false
            
            userDefaults.setBool(false, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.hidden = false
            self.soundsOff.hidden = true
            
            userDefaults.setBool(true, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            skView.presentScene(scene)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func playBackgroundMusic() {
        if let musicURL = NSBundle.mainBundle().URLForResource("bg-music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
    }
}