//
//  StartScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

import FBSDKCoreKit
//import FBSDKLoginKit
//import FBSDKShareKit

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
    
    override func didMove(to view: SKView) {
        water = self.childNode(withName: "water") as! SKSpriteNode
        water2 = self.childNode(withName: "water2") as! SKSpriteNode
        clouds = self.childNode(withName: "clouds") as! SKEmitterNode
        musicOn = self.childNode(withName: "musicOn") as! MSButtonNode
        musicOff = self.childNode(withName: "musicOff") as! MSButtonNode
        soundsOn = self.childNode(withName: "soundsOn") as! MSButtonNode
        soundsOff = self.childNode(withName: "soundsOff") as! MSButtonNode
        
        clouds.advanceSimulationTime(100)
        
        /*let fbLoginView: FBSDKLoginButton = FBSDKLoginButton(frame: CGRect(origin: scene!.position, size: CGSize(width: 200, height: 50)))
        fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "publish_actions"]
        self.view?.addSubview(fbLoginView)*/
        
        let userDefaults = UserDefaults.standard
        let musicIsOn = userDefaults.bool(forKey: "musicSettings")
        let soundsAreOn = userDefaults.bool(forKey: "soundsSettings")
        
        if musicIsOn {
            musicOff.isHidden = true
            playBackgroundMusic()
        }
        else {
            musicOn.isHidden = true
        }
        
        if soundsAreOn {
            soundsOff.isHidden = true
        }
        else {
            soundsOn.isHidden = true
        }
        
        musicOn.selectedHandler = {
            //Turn music off
            self.musicOn.isHidden = true
            self.musicOff.isHidden = false
            
            if let music = self.backgroundMusic {
                music.removeFromParent()
            }
            
            userDefaults.set(false, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.isHidden = false
            self.musicOff.isHidden = true
            
            self.playBackgroundMusic()
            
            userDefaults.set(true, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.isHidden = true
            self.soundsOff.isHidden = false
            
            userDefaults.set(false, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.isHidden = false
            self.soundsOff.isHidden = true
            
            userDefaults.set(true, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            skView.presentScene(scene)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
    }
    
    func scrollSprite(_ sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "bg-music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
}
