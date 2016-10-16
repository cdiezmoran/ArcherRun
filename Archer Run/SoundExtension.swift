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
        run(shootArrowSFX)
    }
    
    func playArrowHitSound() {
        if !soundsAreOn { return }
        
        let arrowHitSFX = SKAction.playSoundFileNamed("arrow-hitting", waitForCompletion: false)
        run(arrowHitSFX)
    }
    
    func playChallengeCompleteSound() {
        if !soundsAreOn { return }
        
        let challengeCompleteSFX = SKAction.playSoundFileNamed("challenge-complete", waitForCompletion: false)
        run(challengeCompleteSFX)
    }
    
    func playCoinGrabSound() {
        if !soundsAreOn { return }
        
        let coinGrabSFX = SKAction.playSoundFileNamed("coin-grab", waitForCompletion: false)
        run(coinGrabSFX)
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "bg-music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    func setMusicAndSoundHandlers() {
        musicOn.selectedHandler = {
            //Turn music off
            self.musicOn.isHidden = true
            self.musicOff.isHidden = false
            
            if let music = self.backgroundMusic {
                music.removeFromParent()
            }
            
            self.musicIsOn = false
            self.userDefaults.set(false, forKey: "musicSettings")
            self.userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.isHidden = false
            self.musicOff.isHidden = true
            
            self.playBackgroundMusic()
            
            self.musicIsOn = true
            self.userDefaults.set(true, forKey: "musicSettings")
            self.userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.isHidden = true
            self.soundsOff.isHidden = false
            
            self.soundsAreOn = false
            self.userDefaults.set(false, forKey: "soundsSettings")
            self.userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.isHidden = false
            self.soundsOff.isHidden = true
            
            self.soundsAreOn = true
            self.userDefaults.set(true, forKey: "soundsSettings")
            self.userDefaults.synchronize()
        }
    }
    
    func toggleMusicAndSoundVisibility() {
        if soundsAreOn! {
            soundsOff.isHidden = true
            soundsOn.isHidden = false
        }
        else {
            soundsOn.isHidden = true
            soundsOff.isHidden = false
        }
        
        if musicIsOn! {
            musicOff.isHidden = true
            musicOn.isHidden = false
        }
        else {
            musicOn.isHidden = true
            musicOff.isHidden = false
        }
    }
}
