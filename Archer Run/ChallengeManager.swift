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
    var userDefaults: UserDefaults!
    
    var activeChallenges = [String: Challenge]()
    var lastGoals = [String: Int]()
    var highestGoals = [String: Int]()
    
    init() {
        userDefaults = UserDefaults.standard
        retreiveChallengesData()
    }
    
    func killedOrc() {
        addToProgressOfType(.Orc)
    }
    
    func ranMeter() {
        addToProgressOfType(.Run)
    }
    
    func hitTarget() {
        addToProgressOfType(.Target)
    }
    
    func collectedCoin() {
        addToProgressOfType(.Coin)
    }
    
    func shotArrow() {
        addToProgressOfType(.Shoot)
    }
    
    func killedUndead() {
        addToProgressOfType(.Undead)
    }
    
    
    func retreiveChallengesData() {
        //Retreive challenges from local storage
        if let dictionary = userDefaults.dictionary(forKey: "lastGoals") {
            lastGoals = dictionary as! [String: Int]
        }
        else {
            lastGoals["orcGoal"] = 0
            lastGoals["runGoal"] = 0
            lastGoals["targetGoal"] = 0
            lastGoals["coinGoal"] = 0
            lastGoals["shootGoal"] = 0
            lastGoals["undeadGoal"] = 0
        }
        
        if let dictionary = userDefaults.dictionary(forKey: "highestGoals") {
            highestGoals = dictionary as! [String: Int]
        }
        else {
            highestGoals["orcHighestOverall"] = 0
            highestGoals["orcHighestSingleGame"] = 0
            highestGoals["orcHighestTimes"] = 0
            highestGoals["runHighestOverall"] = 0
            highestGoals["runHighestSingleGame"] = 0
            highestGoals["runHighestTimes"] = 0
            highestGoals["targetHighestOverall"] = 0
            highestGoals["targetHighestSingleGame"] = 0
            highestGoals["targetHighestTimes"] = 0
            highestGoals["coinHighestOverall"] = 0
            highestGoals["coinHighestSingleGame"] = 0
            highestGoals["coinHighestTimes"] = 0
            highestGoals["shootHighestOverall"] = 0
            highestGoals["shootHighestSingleGame"] = 0
            highestGoals["shootHighestTimes"] = 0
            highestGoals["undeadHighestOverall"] = 0
            highestGoals["undeadHighestSingleGame"] = 0
            highestGoals["undeadHighestTimes"] = 0
        }
        
        let challengesExist = userDefaults.bool(forKey: "challengesExist")
        
        if challengesExist {
            activeChallenges["firstChallenge"] = retrieveChallenge("-first")
            activeChallenges["secondChallenge"] = retrieveChallenge("-second")
            activeChallenges["thirdChallenge"] = retrieveChallenge("-third")
        }
        else {
            //Create initial challenges
            activeChallenges["firstChallenge"] = Challenge(goal: 20, type: .Run, goalType: .SingleGame)
            activeChallenges["secondChallenge"] = Challenge(goal: 2, type: .Orc, goalType: .Overall)
            activeChallenges["thirdChallenge"] = Challenge(goal: 10, type: .Shoot, goalType: .SingleGame)
        }
    }
    
    func storeChallengesData() {
        //Store challenges in local storage
        userDefaults.set(lastGoals, forKey: "lastGoals")
        userDefaults.set(highestGoals, forKey: "highestGoals")
        
        saveChallenge(activeChallenges["firstChallenge"]!, selector: "-first")
        saveChallenge(activeChallenges["secondChallenge"]!, selector: "-second")
        saveChallenge(activeChallenges["thirdChallenge"]!, selector: "-third")
        
        userDefaults.set(true, forKey: "challengesExist")
        
        userDefaults.synchronize()
    }
    
    func saveChallenge(_ challenge: Challenge, selector: String) {
        userDefaults.set(challenge.type.rawValue, forKey: "type" + selector)
        userDefaults.setValue(challenge.goal, forKey: "goal" + selector)
        userDefaults.setValue(challenge.progress, forKey: "progress" + selector)
        userDefaults.setValue(challenge.times, forKey: "times" + selector)
        userDefaults.setValue(challenge.timesProgress, forKey: "timesProgress" + selector)
        userDefaults.set(challenge.goalType.rawValue, forKey: "goalType" + selector)
        userDefaults.set(challenge.state.rawValue, forKey: "state" + selector)
    }
    
    func retrieveChallenge(_ selector: String) -> Challenge {
        let goal = userDefaults.integer(forKey: "goal" + selector)
        let progress = userDefaults.integer(forKey: "progress" + selector)
        let times = userDefaults.integer(forKey: "times" + selector)
        let timesProgress = userDefaults.integer(forKey: "timesProgress" + selector)
        
        let goalTypeRawValue = userDefaults.string(forKey: "goalType" + selector)!
        let goalType = GoalType(rawValue: goalTypeRawValue)!
        
        let typeRawValue = userDefaults.string(forKey: "type" + selector)!
        let type = ChallengeType(rawValue: typeRawValue)!
        
        let stateRawValue = userDefaults.string(forKey: "state" + selector)!
        let state = ChallengeState(rawValue: stateRawValue)!
        
        let newChallenge = Challenge(withProgress: progress, goal: goal, type: type, goalType: goalType, state: state, times: times, timesProgress: timesProgress)
        
        return newChallenge
    }
    
    func addToProgressOfType(_ type: ChallengeType) {
        for (_, challenge) in activeChallenges {
            if challenge.state != .Completed {
                if challenge.type == type {
                    challenge.progress += 1
                    
                    if challenge.goalType == .Times {
                        if !(challenge.timesFlag) {
                            if challenge.goal <= challenge.progress {
                                challenge.timesProgress += 1
                                challenge.timesFlag = true
                            }
                            
                            if challenge.times <= challenge.timesProgress {
                                challenge.state = .Completed
                                challengeCompleted = challenge
                                challenge.didCompleteChallenge = true
                            }
                        }
                    }
                    else {
                        if challenge.goal <= challenge.progress {
                            challenge.state = .Completed
                            challengeCompleted = challenge
                            challenge.didCompleteChallenge = true
                        }
                    }
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
                
                if challenge.goalType == .Times && !(challenge.timesFlag) {
                    challenge.progress = 0
                    challenge.timesProgress = 0
                }
                else if challenge.goalType == .Times && challenge.timesFlag {
                    challenge.progress = 0
                    challenge.timesFlag = false
                }
            }
        }
    }
    
    func replaceChallengeForKey(_ key: String) {
        let oldChallenge = activeChallenges[key]!
        //get last challenge info
        let lastGoal = oldChallenge.goal
        let lastType = oldChallenge.type
        let lastGoalType = oldChallenge.goalType
        //save last goal
        let lastGoalsKey = lastType.rawValue + "Goal"
        lastGoals[lastGoalsKey] = lastGoal
        
        if lastType == .Orc {
            if lastGoalType == .Overall {
                highestGoals["orcHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["orcHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["orcHighestTimes"] = lastGoal
            }
        }
        else if lastType == .Run {
            if lastGoalType == .Overall {
                highestGoals["runHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["runHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["runHighestTimes"] = lastGoal
            }
        }
        else if lastType == .Target {
            if lastGoalType == .Overall {
                highestGoals["targetHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["targetHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["targetHighestTimes"] = lastGoal
            }
        }
        else if lastType == .Coin {
            if lastGoalType == .Overall {
                highestGoals["coinHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["coinHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["coinHighestTimes"] = lastGoal
            }
        }
        else if lastType == .Shoot {
            if lastGoalType == .Overall {
                highestGoals["shootHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["shootHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["shootHighestTimes"] = lastGoal
            }
        }
        else if lastType == .Undead {
            if lastGoalType == .Overall {
                highestGoals["undeadHighestOverall"] = lastGoal
            }
            else if lastGoalType == .SingleGame {
                highestGoals["undeadHighestSingleGame"] = lastGoal
            }
            else if lastGoalType == .Times {
                highestGoals["undeadHighestTimes"] = lastGoal
            }
        }
        
        //Get new type
        var newType: ChallengeType!
        repeat {
            let randomSelector = CGFloat.random(min: 0.0, max: 1.0)
            if randomSelector >= 0 && randomSelector < 0.6 {
                let randomNumber = Int(arc4random_uniform(2))
                switch randomNumber {
                case 0:
                    newType = .Orc
                    break
                case 1:
                    newType = .Run
                    break
                default:
                    newType = lastType
                    break
                }
            }
            else if randomSelector >= 0.6 && randomSelector < 0.9{
                let randomNumber = Int(arc4random_uniform(2))
                switch randomNumber {
                case 0:
                    newType = .Coin
                    break
                case 1:
                    newType = .Shoot
                    break
                default:
                    newType = lastType
                }
            }
            else if randomSelector >= 0.9 {
                let randomNumber = Int(arc4random_uniform(2))
                switch randomNumber {
                case 0:
                    newType = .Target
                    break
                case 1:
                    newType = .Undead
                    break
                default:
                    newType = lastType
                    break
                }
            }
        } while newType == lastType
        
        //Get new goal type
        var newGoalType: GoalType!
        repeat {
            let randomSelector = CGFloat.random(min: 0.0, max: 1.0)
            if randomSelector >= 0 && randomSelector < 0.4 {
                newGoalType = .Overall
            }
            else if randomSelector >= 0.4 && randomSelector < 0.8 {
                newGoalType = .SingleGame
            }
            else if randomSelector >= 0.8 {
                newGoalType = .Times
            }
        } while isGoalAndTypeEqual(newGoalType, type: newType)
        
        //Get new goal
        var newGoal: Int!
        var newTimes: CGFloat = 1
        
        /*---------------------------CHALLENGE GOAL GENERATION LOGIC-----------------------------*/
        
        if newType == .Orc {
            if newGoalType == .Overall {
                newGoal = highestGoals["orcHighestOverall"]! + 4
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["orcHighestSingleGame"]! + 2
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["orcHighestTimes"]! + 1
                newTimes += CGFloat(newGoal) * 0.2
            }
        }
        else if newType == .Run {
            if newGoalType == .Overall {
              newGoal = highestGoals["runHighestOverall"]! + 75
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["runHighestSingleGame"]! + 50
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["runHighestTimes"]! + 20
                newTimes += CGFloat(newGoal / 20) * 0.2
            }
        }
        else if newType == .Coin {
            if newGoalType == .Overall {
                newGoal = highestGoals["coinHighestOverall"]! + 75
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["coinHighestSingleGame"]! + 50
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["coinHighestTimes"]! + 25
                newTimes += CGFloat(newGoal / 25) * 0.2
            }
        }
        else if newType == .Target {
            if newGoalType == .Overall {
                newGoal = highestGoals["targetHighestOverall"]! + 3
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["targetHighestSingleGame"]! + 2
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["targetHighestTimes"]! + 1
                newTimes += CGFloat(newGoal) * 0.2
            }
        }
        else if newType == .Shoot {
            if newGoalType == .Overall {
                newGoal = highestGoals["shootHighestOverall"]! + 25
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["shootHighestSingleGame"]! + 10
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["shootHighestTimes"]! + 5
                newTimes += CGFloat(newGoal / 5) * 0.2
            }
        }
        else if newType == .Undead {
            if newGoalType == .Overall {
                newGoal = highestGoals["undeadHighestOverall"]! + 3
            }
            else if newGoalType == .SingleGame {
                newGoal = highestGoals["undeadHighestSingleGame"]! + 2
            }
            else if newGoalType == .Times {
                newGoal = highestGoals["undeadHighestTimes"]! + 1
                newTimes += CGFloat(newGoal) * 0.2
            }
        }
        
        /*------------------------END OF CHALLENGE GOAL GENERATION LOGIC--------------------------*/
        
        if newGoalType == .Times {
            var roundedTimes = Int(round(newTimes))
            if roundedTimes < 2 {
                roundedTimes = 2
            }
            activeChallenges[key] = Challenge(withTimes: roundedTimes, goal: newGoal, type: newType)
        }
        else {
            activeChallenges[key] = Challenge(goal: newGoal, type: newType, goalType: newGoalType)
        }
    }
    
    func isGoalAndTypeEqual(_ goalType: GoalType, type: ChallengeType) -> Bool {
        for (_, challenge) in activeChallenges {
            if challenge.type == type && challenge.goalType == goalType {
                return true
            }
        }
        return false
    }
    
    func checkForCompletedChallenges() -> [String: Challenge] {
        var completedChallenges = [String: Challenge]()
        for (key, challenge) in activeChallenges {
            if challenge.state == .Completed {
                replaceChallengeForKey(key)
                completedChallenges[key] = challenge
            }
        }
        
        return completedChallenges
    }
    
    func notifyOnChallengeCompletion() -> Bool {
        for (_, challenge) in activeChallenges {
            if challenge.didCompleteChallenge {
                challenge.didCompleteChallenge = false
                return true
            }
        }
        return false
    }
}
