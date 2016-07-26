//
//  Challenge.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/25/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

enum ChallengeType: String {
    case Orc = "orc"
    case Run = "run"
    case Target = "target"
    case Coin = "coin"
    case Shoot = "shoot"
}

enum ChallengeState: String {
    case Active = "activeChallengeState"
    case Completed = "completedChallengeState"
}

enum GoalType: String {
    case SingleGame = "singleGame"
    case Times = "times"
    case Overall = "overall"
}

class Challenge {
    
    var goal: Int
    var goalType: GoalType
    var progress: Int
    var state: ChallengeState
    var type: ChallengeType
    var times: Int
    
    init(goal: Int, type: ChallengeType, goalType: GoalType) {
        self.goal = goal
        self.goalType = goalType
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = 1
    }
    
    init(withTimes times: Int, goal: Int, type: ChallengeType) {
        self.goal = goal
        self.goalType = .Times
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = times
    }
    
    init(withProgress progress: Int, goal: Int, type: ChallengeType, goalType: GoalType, state: ChallengeState) {
        self.goal = goal
        self.goalType = goalType
        self.progress = progress
        self.state = state
        self.type = type
        self.times = 1
    }
    
    func description() -> String {
        var descriptionString: String
        
        switch type {
        case .Orc:
            descriptionString = "Kill \(self.goal) Orcs"
            break
        case .Run:
            descriptionString = "Run \(self.goal) meters"
            break
        case .Target:
            descriptionString = "Hit \(self.goal) targets"
            break
        case .Coin:
            descriptionString = "Collect \(self.goal) coins"
            break
        case .Shoot:
            descriptionString = "Shoot \(self.goal) arrows"
        }
        
        if  goalType == .Times {
            descriptionString += " \(times) times"
        }
        
        if goalType == .SingleGame {
            descriptionString += " in a single run"
        }
        
        return descriptionString
    }
}
