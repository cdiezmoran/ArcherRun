//
//  LevelManager.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/28/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class LevelManager {
    
    static let sharedInstance = LevelManager()
    
    var didLevelUp: Bool = false
    var level: Double = 1.0
    var expRequired: Int!
    var lastExpRequired: Int!
    var progress: Int = 0
    var lastProgress: Int = 0
    
    var userDefaults: NSUserDefaults!
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
        retrieveLevelData()
        expRequired = findExpRequired(level)
        lastExpRequired = expRequired
    }
    
    func retrieveLevelData() {
        level = userDefaults.doubleForKey("userLevel")
        if level == 0 {
            level = 1
        }
        progress = userDefaults.integerForKey("expProgress")
    }
    
    func storeLevelData() {
        userDefaults.setValue(level, forKey: "userLevel")
        userDefaults.setValue(progress, forKey: "expProgress")
        userDefaults.synchronize()
    }
    
    func gainExp() {
        lastProgress = progress
        
        let levelDiv = level / 5
        
        for i in 1...10 {
            if levelDiv > Double(i-1) && levelDiv <= Double(i) {
                progress += 500 * i
            }
        }
        
        if progress >= expRequired {
            levelUp()
            progress = 0
            lastProgress = 0
        }
        storeLevelData()
    }
    
    func levelUp() {
        level += 1
        didLevelUp = true
        lastExpRequired = expRequired
        expRequired = findExpRequired(level)
    }
    
    func getProgressBarXScale() -> CGFloat {
        let progressBarXScale: CGFloat = CGFloat(progress - lastProgress) / CGFloat(expRequired)
        
        return progressBarXScale
    }
    
    func getLastProgressBarXScale() -> CGFloat {
        let progressBarXScale: CGFloat = CGFloat(lastProgress) / CGFloat(expRequired)
        
        return progressBarXScale
    }
        
    //Find fibonacci number for a given nth number
    func findExpRequired (nthNumber : Double) -> Int {
        let phiOne : Double = (1.0 + sqrt(5.0)) / 2.0
        let phiTwo : Double = (1.0 - sqrt(5.0)) / 2.0
        let nthNumber : Double = (pow(phiOne, nthNumber) - (pow(phiTwo, nthNumber))) / sqrt(5.0)
        return Int(nthNumber) * 1000
    }
}
