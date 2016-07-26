//
//  ChallengeManager.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/25/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class ChallengeManager {
    static let sharedInstance = ChallengeManager()
    
    var challengeCompleted: Challenge!
    var didCompleteChallenge: Bool = false
    var userDefaults: NSUserDefaults!
    
    var activeChallenges = [String: Challenge]()
    
    var lastGoals = [String: Int]()
    var lastGoalTypes = [String: GoalType]()
    
    var highestGoals = [String: Int]()
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
        retreiveChallengesData()
    }
    
    func killedOrc() {
        addToProgressOfType(.Orc, progress: nil)
    }
    
    func ranMeters(meters: Int) {
        addToProgressOfType(.Run, progress: meters)
    }
    
    func hitTarget() {
        addToProgressOfType(.Target, progress: nil)
    }
    
    func collectedCoin() {
        addToProgressOfType(.Coin, progress: nil)
    }
    
    func shotArrow() {
        addToProgressOfType(.Shoot, progress: nil)
    }
    
    
    func retreiveChallengesData() {
        //Retreive challenges from local storage
        if let dictionary = userDefaults.dictionaryForKey("lastGoals") {
            lastGoals = dictionary as! [String: Int]
        }
        else {
            lastGoals["orcGoal"] = 0
            lastGoals["runGoal"] = 0
            lastGoals["targetGoal"] = 0
            lastGoals["coinGoal"] = 0
            lastGoals["shootGoal"] = 0
        }
        
        /*if let dictionary = userDefaults.dictionaryForKey("lastGoalTypes") {
            for (key, rawValue) in dictionary {
                lastGoalTypes[key] = GoalType(rawValue: rawValue as! String)
            }
        }
        else {
            lastGoalTypes["orcGoalType"] = .Overall
            lastGoalTypes["runGoalType"] = .Overall
            lastGoalTypes["targetGoalType"] = .Overall
            lastGoalTypes["coinGoalType"] = .Overall
            lastGoalTypes["ShootGoalType"] = .Overall
        }*/
        
        let challengesExist = userDefaults.boolForKey("challengesExist")
        
        if challengesExist {
            activeChallenges["firstChallenge"] = retrieveChallenge("-first")
            activeChallenges["secondChallenge"] = retrieveChallenge("-second")
            activeChallenges["thirdChallenge"] = retrieveChallenge("-third")
        }
        else {
            //Create initial challenges
            activeChallenges["firstChallenge"] = Challenge(goal: 100, type: .Run, goalType: .SingleGame)
            activeChallenges["secondChallenge"] = Challenge(goal: 3, type: .Orc, goalType: .Overall)
            activeChallenges["thirdChallenge"] = Challenge(goal: 10, type: .Shoot, goalType: .SingleGame)
        }
    }
    
    func storeChallengesData() {
        //Store challenges in local storage
        userDefaults.setObject(lastGoals, forKey: "lastGoals")
        
        saveChallenge(activeChallenges["firstChallenge"]!, selector: "-first")
        saveChallenge(activeChallenges["secondChallenge"]!, selector: "-second")
        saveChallenge(activeChallenges["thirdChallenge"]!, selector: "-third")
        
        userDefaults.setBool(true, forKey: "challengesExist")
        
        userDefaults.synchronize()
    }
    
    func saveChallenge(challenge: Challenge, selector: String) {
        userDefaults.setObject(challenge.type.rawValue, forKey: "type" + selector)
        userDefaults.setValue(challenge.goal, forKey: "goal" + selector)
        userDefaults.setValue(challenge.progress, forKey: "progress" + selector)
        userDefaults.setValue(challenge.times, forKey: "times" + selector)
        userDefaults.setObject(challenge.goalType.rawValue, forKey: "goalType" + selector)
        userDefaults.setObject(challenge.state.rawValue, forKey: "state" + selector)
    }
    
    func retrieveChallenge(selector: String) -> Challenge {
        let goal = userDefaults.integerForKey("goal" + selector)
        let progress = userDefaults.integerForKey("progress" + selector)
        
        let goalTypeRawValue = userDefaults.stringForKey("goalType" + selector)!
        let goalType = GoalType(rawValue: goalTypeRawValue)!
        
        let typeRawValue = userDefaults.stringForKey("type" + selector)!
        let type = ChallengeType(rawValue: typeRawValue)!
        
        let stateRawValue = userDefaults.stringForKey("state" + selector)!
        let state = ChallengeState(rawValue: stateRawValue)!
        
        let newChallenge = Challenge(withProgress: progress, goal: goal, type: type, goalType: goalType, state: state)
        
        return newChallenge
    }
    
    func addToProgressOfType(type: ChallengeType, progress: Int?) {
        for (_, challenge) in activeChallenges {
            if challenge.state != .Completed {
                if challenge.type == type {
                    if let progress = progress {
                        challenge.progress = progress
                    }
                    else {
                        challenge.progress += 1
                    }
                }
                
                if challenge.goal >= challenge.progress {
                    challenge.state = .Completed
                    challengeCompleted = challenge
                    didCompleteChallenge = true
                }
            }
        }
    }
    
    func cleanUpOnGameOver() {
        for (_, challenge) in activeChallenges {
            if challenge.state != .Completed {
                if challenge.goalType == .SingleGame {
                    challenge.progress = 0
                }
            }
        }
    }
    
    func replaceChallengeForKey(key: String) {
        let oldChallenge = activeChallenges[key]!
        //get last challenge info
        let lastGoal = oldChallenge.goal
        let lastType = oldChallenge.type
        let lastGoalType = oldChallenge.goalType
        //save last goal
        let lastGoalsKey = lastType.rawValue + "Goal"
        lastGoals[lastGoalsKey] = lastGoal
        
        let lastGoalTypesKey = lastGoalType.rawValue + "GoalType"
        lastGoalTypes[lastGoalTypesKey] = lastGoalType

        //Get new type
        var newType: ChallengeType!
        while newType == lastType {
            let randomSelector = arc4random_uniform(5)
            switch randomSelector {
            case 0:
                newType = .Orc
                break
            case 1:
                newType = .Run
                break
            case 2:
                newType = .Coin
                break
            case 3:
                newType = .Target
                break
            case 4:
                newType = .Shoot
                break
            default:
                newType = lastType
                break
            }
        }
        
        //Get new goal type
        var newGoalType: GoalType!
        let randomSelector = arc4random_uniform(3)
        switch randomSelector {
        case 0:
            newGoalType = .Overall
            break
        case 1:
            newGoalType = .SingleGame
            break
        case 2:
            newGoalType = .Times
            break
        default:
            newGoalType = .Overall
            break
        }
        //Get new goal
        var newGoal: Int!
        
        /*---------------------------CHALLENGE GENERATION LOGIC-----------------------------*/
        //Don't know how to explain this but i hope it works decently.
        //And i also hope you don't try to understand this.
        
        /*var tempLastGoalType: GoalType!
        var tempLastGoal: Int!
        
        if newType == .Run {
            tempLastGoalType = lastGoalTypes["runGoalType"]
            tempLastGoal = lastGoals["runGoal"]
            
            if tempLastGoalType == .Overall {
                if newGoalType == .Overall {
                    newGoal = tempLastGoal + 250
                }
                else if newGoalType == .SingleGame {
                    newGoal = tempLastGoal - 150
                    if newGoal <= 0 {
                        newGoal = 100
                    }
                }
                else if newGoalType == .Times {
                    newGoal = tempLastGoal - 250
                    if newGoal <= 0 {
                        newGoal = 100
                    }
                }
            }
            else if tempLastGoalType == .SingleGame {
                if newGoalType == .Overall {
                    newGoal = tempLastGoal + 350
                }
                else if newGoalType == .SingleGame {
                    newGoal = tempLastGoal + 150
                }
                else if newGoalType == .Times {
                    newGoal = tempLastGoal - 100
                    if newGoal <= 0 {
                        newGoal = 100
                    }
                }
            }
            else if tempLastGoalType == .Times {
                if newGoalType == .Overall {
                    newGoal = tempLastGoal + 500
                }
                else if newGoalType == .SingleGame {
                    newGoal =
                }
            }
        }*/
        
        /*------------------------END OF CHALLENGE GENERATION LOGIC--------------------------*/
        
        /*switch newType! {
        case .Orc:
            newGoal = lastGoals["orcGoal"]! + 3
            break
        case .Run:
            newGoal = lastGoals["runGoal"]! + 250
            break
        case .Coin:
            newGoal = lastGoals["coinGoal"]! + 100
            break
        case .Target:
            newGoal = lastGoals["targetGoal"]! + 1
            break
        case .Shoot:
            newGoal = lastGoals["shootGoal"]! + 30
            break
        }*/
    }
}


















