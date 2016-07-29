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
    
    var didCompleteChallenge: Bool = false
    var goal: Int
    var goalType: GoalType
    var progress: Int
    var state: ChallengeState
    var type: ChallengeType
    var times: Int
    var timesFlag: Bool = false
    var timesProgress: Int
    
    init(goal: Int, type: ChallengeType, goalType: GoalType) {
        self.goal = goal
        self.goalType = goalType
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = 1
        self.timesProgress = 0
    }
    
    init(withTimes times: Int, goal: Int, type: ChallengeType) {
        self.goal = goal
        self.goalType = .Times
        self.progress = 0
        self.state = .Active
        self.type = type
        self.times = times
        self.timesProgress = 0
    }
    
    init(withProgress progress: Int, goal: Int, type: ChallengeType, goalType: GoalType, state: ChallengeState, times: Int, timesProgress: Int) {
        self.goal = goal
        self.goalType = goalType
        self.progress = progress
        self.state = state
        self.type = type
        self.times = times
        self.timesProgress = timesProgress
    }
    
    func description() -> String {
        var descriptionString: String
        
        switch type {
        case .Orc:
            if self.goal == 1 { descriptionString = "Kill \(self.goal) Orc" }
            else { descriptionString = "Kill \(self.goal) Orcs" }
            break
        case .Run:
            if self.goal == 1 { descriptionString = "Run \(self.goal) meter" }
            else { descriptionString = "Run \(self.goal) meters" }
            break
        case .Target:
            if self.goal == 1 { descriptionString = "Hit \(self.goal) target" }
            else { descriptionString = "Hit \(self.goal) targets" }
            break
        case .Coin:
            if self.goal == 1 { descriptionString = "Collect \(self.goal) coin" }
            else { descriptionString = "Collect \(self.goal) coins" }
            break
        case .Shoot:
            if self.goal == 1 { descriptionString = "Shoot \(self.goal) arrow" }
            else { descriptionString = "Shoot \(self.goal) arrows" }
            break
        }
        
        if  goalType == .Times {
            descriptionString += " \(times) times in a row"
        }
        
        if goalType == .SingleGame {
            descriptionString += " in a single run"
        }
        
        return descriptionString
    }
    
    func progressDescription() -> String {
        var progressString: String
        
        if goalType == .Times {
            let timesToGo =  times - timesProgress
            if timesToGo == 1 {
                progressString = "\(timesToGo) time to go"
            }
            else {
                progressString = "\(timesToGo) times to go"
            }
        }
        else {
            let toGo = goal - progress
            switch type {
            case .Orc:
                if toGo == 1 { progressString = "\(toGo) orc to go" }
                else { progressString = "\(toGo) orcs to go" }
                break
            case .Run:
                if toGo == 1 { progressString = "\(toGo) meter to go" }
                else { progressString = "\(toGo) meters to go" }
                break
            case .Target:
                if toGo == 1 { progressString = "\(toGo) target to go" }
                else { progressString = "\(toGo) targets to go" }
                break
            case .Coin:
                if toGo == 1 { progressString = "\(toGo) coin to go" }
                else { progressString = "\(toGo) coins to go" }
                break
            case .Shoot:
                if toGo == 1 { progressString = "\(toGo) arrow to go" }
                else { progressString = "\(toGo) arrows to go" }
                break
            }
        }
        
        return progressString
    }
}
