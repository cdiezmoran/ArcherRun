//
//  ChallengesExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/15/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    func setChallengeLabels() {
        firstChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["firstChallenge"]!.description()
        secondChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["secondChallenge"]!.description()
        thirdChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["thirdChallenge"]!.description()
    }
    
    func setProgressLabels() {
        firstProgressLabel.text = ChallengeManager.sharedInstance.activeChallenges["firstChallenge"]!.progressDescription()
        secondProgressLabel.text = ChallengeManager.sharedInstance.activeChallenges["secondChallenge"]!.progressDescription()
        thirdProgressLabel.text = ChallengeManager.sharedInstance.activeChallenges["thirdChallenge"]!.progressDescription()
    }
    
    func setChallengeIcons() {
        let activeChallenges = ChallengeManager.sharedInstance.activeChallenges
        for (key, challenge) in activeChallenges {
            if key == "firstChallenge" {
                firstChallengeIcon.texture = challenge.getTexture()
                firstChallengeIconBG.color = challenge.getBGColor()
            }
            else if key == "secondChallenge" {
                secondChallengeIcon.texture = challenge.getTexture()
                secondChallengeIconBG.color = challenge.getBGColor()
            }
            else if key == "thirdChallenge" {
                thirdChallengeIcon.texture = challenge.getTexture()
                thirdChallengeIconBG.color = challenge.getBGColor()
            }
        }
    }
    
    func showChallengesAtGameStart() {
        //Show banner
        let showBanner = SKAction.moveTo(y: 355, duration: 0.5)
        
        //Get first challenge info
        let updateInfoFirst = SKAction.run({
            self.updateForChallengeKey("firstChallenge")
        })
        //wait for 0.5 seconds
        let wait = SKAction.wait(forDuration: 1.5)
        //repeat for other to challenges
        let updateInfoSecond = SKAction.run({
            self.updateForChallengeKey("secondChallenge")
        })
        let updateInfoThird = SKAction.run({
            self.updateForChallengeKey("thirdChallenge")
        })
        //Hide banner
        let hideBanner = SKAction.moveTo(y: 446.5, duration: 0.5)
        
        //Run action
        let sequence = SKAction.sequence([updateInfoFirst, showBanner, wait, updateInfoSecond, wait, updateInfoThird, wait, hideBanner])
        challengeActiveBanner.run(sequence)
    }
    
    func updateForChallengeKey(_ key: String) {
        let challenge = ChallengeManager.sharedInstance.activeChallenges[key]!
        challengeActiveLabel.text = challenge.description()
        challengeActiveProgress.text = challenge.progressDescription()
        challengeIconBG.color = challenge.getBGColor()
        challengeIcon.texture = challenge.getTexture()
    }
}
