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
    
    var level: Double!
    var expRequired: Int!
    var progress: Int!
    
    var userDefaults: NSUserDefaults!
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
        retrieveLevelData()
    }
    
    func retrieveLevelData() {
        userDefaults.doubleForKey("userLevel")
        userDefaults.integerForKey("expProgress")
    }
    
    func storeLevelData() {
        userDefaults.setValue(level, forKey: "userLevel")
        userDefaults.setValue(progress, forKey: "expProgress")
    }
    
    //Find fibonacci number for a given nth number
    func findExpRequired (nthNumber : Double) -> Int {
        let phiOne : Double = (1.0 + sqrt(5.0)) / 2.0
        let phiTwo : Double = (1.0 - sqrt(5.0)) / 2.0
        let nthNumber : Double = (pow(phiOne, nthNumber) - (pow(phiTwo, nthNumber))) / sqrt(5.0)
        return Int(nthNumber)
    }
    
}
