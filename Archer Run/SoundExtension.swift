//
//  SoundExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/5/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    func playShootArrowSound() {
        if !soundsAreOn { return }
        
        let shootArrowSFX = SKAction.playSoundFileNamed("arrow-shoot", waitForCompletion: false)
        runAction(shootArrowSFX)
    }
    
    func playArrowHitSound() {
        if !soundsAreOn { return }
        
        let arrowHitSFX = SKAction.playSoundFileNamed("arrow-hitting", waitForCompletion: false)
        runAction(arrowHitSFX)
    }
    
    func playChallengeCompleteSound() {
        if !soundsAreOn { return }
        
        let challengeCompleteSFX = SKAction.playSoundFileNamed("challenge-complete", waitForCompletion: false)
        runAction(challengeCompleteSFX)
    }
    
    func playCoinGrabSound() {
        if !soundsAreOn { return }
        
        let coinGrabSFX = SKAction.playSoundFileNamed("coin-grab", waitForCompletion: false)
        runAction(coinGrabSFX)
    }
    
    func playBackgroundMusic() {
        if let musicURL = NSBundle.mainBundle().URLForResource("bg-music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    func checkMusicAndSoundSettings() {
        if soundsAreOn! {
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
            
            self.userDefaults.setBool(false, forKey: "musicSettings")
            self.userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.hidden = false
            self.musicOff.hidden = true
            
            self.playBackgroundMusic()
            
            self.userDefaults.setBool(true, forKey: "musicSettings")
            self.userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.hidden = true
            self.soundsOff.hidden = false
            
            self.userDefaults.setBool(false, forKey: "soundsSettings")
            self.userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.hidden = false
            self.soundsOff.hidden = true
            
            self.userDefaults.setBool(true, forKey: "soundsSettings")
            self.userDefaults.synchronize()
        }
    }
}
