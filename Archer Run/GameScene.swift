//
//  GameScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:        UInt32 = 0          // 0000
    static let Player:      UInt32 = 0b1        // 0001
    static let Obstacle:    UInt32 = 0b10       // 0010
    static let Coin:        UInt32 = 0b100      // 0100
    static let Floor:       UInt32 = 0b1000     // 1000
    static let Arrow:       UInt32 = 0b10000    // 10000
    static let Target:      UInt32 = 0b100000
    static let IceBlock:    UInt32 = 0b1000000
    static let Heart:       UInt32 = 0b10000000
}

class GameScene: SKScene, SKPhysicsContactDelegate, ScrollListDelegate {
    var gameState: GKStateMachine!
    var gameOverState: GKState!
    var playingState: GKState!
    var startingState: GKState!
    var tutorialState: GKState!
    
    var arrows: [Arrow] = []
    var availableArrows = [String:Bool]()
    var coinCount: Int = 0 {
        didSet {
            coinCountLabel.text = String(coinCount)
        }
    }
    var currentLevelHolder: String = "levelHolder1"
    var didTutJump: Bool = false
    var didTutShoot: Bool = false
    var firstTouchLocation = CGPointZero
    var hearts = [SKSpriteNode]()
    var intervalMin: CGFloat = 0.5
    var intervalMax:CGFloat = 1.5
    var lastRoundedScore: Int = 0
    var lastUpdateTime: CFTimeInterval = 0
    var list: ScrollingList!
    var playedGames: Int = 0
    var randomInterval: CGFloat!
    var score: CGFloat = 0 {
        didSet {
            let roundedScore = Int(round(score))
            scoreLabel.text = "\(roundedScore)m"
            if lastRoundedScore != roundedScore {
                ChallengeManager.sharedInstance.ranMeter()
            }
            lastRoundedScore = roundedScore
        }
    }
    var timer: CFTimeInterval = 0
    var arrowTimer: CFTimeInterval = 0.4
    var hurtTimer: CFTimeInterval = 0
    var deltaTime: Double!
    var userDefaults: NSUserDefaults!
    
    var archer: Archer!
    var challengeCompletedBanner: SKSpriteNode!
    var challengeCompletedLabel: SKLabelNode!
    var clouds: SKEmitterNode!
    var coinCountLabel: SKLabelNode!
    var coinRewardLabel: SKLabelNode!
    var enemyScrollLayer: SKNode!
    var enemyScrollLayerFast: SKNode!
    var enemyScrollLayerSlow: SKNode!
    var firstChallengeLabel: SKLabelNode!
    var firstCompletedSprite: SKSpriteNode!
    var firstProgressLabel: SKLabelNode!
    var gameOverScreen: SKSpriteNode!
    var highScoreLabel: SKLabelNode!
    var invisibleGround: SKSpriteNode!
    var levelHolder1: SKSpriteNode!
    var levelHolder2: SKSpriteNode!
    var levelLabel: SKLabelNode!
    var levelProgressBar: SKSpriteNode!
    var mountains1: SKSpriteNode!
    var mountains2: SKSpriteNode!
    var obstacleScrollLayer: SKNode!
    var playAgainButton: MSButtonNode!
    var startGroundLarge: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var scoreLabelGO: SKLabelNode!
    var secondChallengeLabel: SKLabelNode!
    var secondCompletedSprite: SKSpriteNode!
    var secondProgressLabel: SKLabelNode!
    var shopButton: MSButtonNode!
    var startMountains: SKSpriteNode!
    var startingScrollLayer: SKNode!
    var startTreesBack: SKSpriteNode!
    var startTreesFront: SKSpriteNode!
    var thirdChallengeLabel: SKLabelNode!
    var thirdCompletedSprite: SKSpriteNode!
    var thirdProgressLabel: SKLabelNode!
    var totalCoinCountLabel: SKLabelNode!
    var treesBack1: SKSpriteNode!
    var treesBack2: SKSpriteNode!
    var treesFront1: SKSpriteNode!
    var treesFront2: SKSpriteNode!
    var water: SKSpriteNode!
    var water2: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        archer = Archer()
        addChild(archer)
        
        challengeCompletedBanner = self.childNodeWithName("challengeCompletedBanner") as! SKSpriteNode
        challengeCompletedLabel = self.childNodeWithName("//challengeCompletedLabel") as! SKLabelNode
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        coinCountLabel = self.childNodeWithName("coinCountLabel") as! SKLabelNode
        coinRewardLabel = self.childNodeWithName("//coinRewardLabel") as! SKLabelNode
        enemyScrollLayer = self.childNodeWithName("enemyScrollLayer")
        enemyScrollLayerFast = self.childNodeWithName("enemyScrollLayerFast")
        enemyScrollLayerSlow = self.childNodeWithName("enemyScrollLayerSlow")
        firstChallengeLabel = self.childNodeWithName("//firstChallengeLabel") as! SKLabelNode
        firstCompletedSprite = self.childNodeWithName("//firstCompletedSprite") as! SKSpriteNode
        firstProgressLabel = self.childNodeWithName("//firstProgressLabel") as! SKLabelNode
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        highScoreLabel = self.childNodeWithName("//highScoreLabel") as! SKLabelNode
        invisibleGround = self.childNodeWithName("//invisibleGround") as! SKSpriteNode
        levelHolder1 = self.childNodeWithName("levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNodeWithName("levelHolder2") as! SKSpriteNode
        levelLabel = self.childNodeWithName("//levelLabel") as! SKLabelNode
        levelProgressBar = self.childNodeWithName("//levelProgressBar") as! SKSpriteNode
        mountains1 = self.childNodeWithName("mountains1") as! SKSpriteNode
        mountains2 = self.childNodeWithName("mountains2") as! SKSpriteNode
        obstacleScrollLayer = self.childNodeWithName("obstacleScrollLayer")
        playAgainButton = self.childNodeWithName("//playAgainButton") as! MSButtonNode
        startGroundLarge = self.childNodeWithName("//startGroundLarge") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabelGO = self.childNodeWithName("//scoreLabelGO") as! SKLabelNode
        secondChallengeLabel = self.childNodeWithName("//secondChallengeLabel") as! SKLabelNode
        secondCompletedSprite = self.childNodeWithName("//secondCompletedSprite") as! SKSpriteNode
        secondProgressLabel = self.childNodeWithName("//secondProgressLabel") as! SKLabelNode
        shopButton = self.childNodeWithName("//shopButton") as! MSButtonNode
        startMountains = self.childNodeWithName("startMountains") as! SKSpriteNode
        startingScrollLayer = self.childNodeWithName("startingScrollLayer")
        startTreesBack = self.childNodeWithName("startTreesBack") as! SKSpriteNode
        startTreesFront = self.childNodeWithName("startTreesFront") as! SKSpriteNode
        thirdChallengeLabel = self.childNodeWithName("//thirdChallengeLabel") as! SKLabelNode
        thirdCompletedSprite = self.childNodeWithName("//thirdCompletedSprite") as! SKSpriteNode
        thirdProgressLabel = self.childNodeWithName("//thirdProgressLabel") as! SKLabelNode
        totalCoinCountLabel = self.childNodeWithName("//totalCoinCountLabel") as! SKLabelNode
        treesBack1 = self.childNodeWithName("treesBack1") as! SKSpriteNode
        treesBack2 = self.childNodeWithName("treesBack2") as! SKSpriteNode
        treesFront1 = self.childNodeWithName("treesFront1") as! SKSpriteNode
        treesFront2 = self.childNodeWithName("treesFront2") as! SKSpriteNode
        water = self.childNodeWithName("//water") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        
        clouds.advanceSimulationTime(320)
        
        coinRewardLabel.hidden = true
        
        setupGroundPhysics()
        
        gameOverState = GameOverState(scene: self)
        playingState = PlayingState(scene: self)
        startingState = StartingState(scene: self)
        tutorialState = TutorialState(scene: self)
        
        gameState = GKStateMachine(states: [startingState, playingState, gameOverState, tutorialState])
        
        randomInterval = CGFloat.random(min: 0.3, max: 1)
        
        playAgainButton.selectedHandler = {
            if let scene = GameScene(fileNamed:"GameScene") {
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .Fill
                
                skView.presentScene(scene)
            }
        }
        shopButton.selectedHandler = {
            self.list = ScrollingList(size: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.9))
            self.list.horizontalAlignmentMode = .Left
            self.list.zPosition = self.gameOverScreen.zPosition + 50
            self.list.color = UIColor(red: 125/255, green: 82/255, blue: 48/255, alpha: 1)
            self.setupList()
        }
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        playedGames = userDefaults.integerForKey("playedGames")
        
        if let dict = userDefaults.dictionaryForKey("availableArrows") {
            availableArrows = dict as! [String:Bool]
        }
        else {
            availableArrows["regular"] = true
            availableArrows["ice"] = false
            availableArrows["fire"] = false
            availableArrows["explosive"] = false
            userDefaults.setObject(availableArrows, forKey: "availableArrows")
            userDefaults.synchronize()
        }
        
        setChallengeLabels()
        setProgressLabels()
        levelLabel.text = String(Int(LevelManager.sharedInstance.level))
        levelProgressBar.xScale = LevelManager.sharedInstance.getProgressBarXScale()
        
        addHeart()
        addHeart()
        
        gameState.enterState(StartingState)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Get references to bodies involved in collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        let categoryA = nodeA.physicsBody?.categoryBitMask
        let categoryB = nodeB.physicsBody?.categoryBitMask
        
        /* Player contact with floor */
        if  (categoryA == PhysicsCategory.Floor && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Floor) {
            
            if archer.state == .HurtJump || archer.state == .HurtDoubleJump {
                archer.state = .Hurt
            }
            
            if archer.state == .Dead || archer.state == .Running || archer.state == .Hurt { return }
            
            archer.run()
            
            if gameState.currentState is StartingState {
                if playedGames < 3 {
                    gameState.enterState(TutorialState)
                }
                else {
                    gameState.enterState(PlayingState)
                }
            }
        }
        
        /* Player contact with obstacle */
        if (categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Obstacle) {
            if archer.state == .Hurt || archer.state == .HurtJump || archer.state == .HurtDoubleJump { return }
            
            archer.lives -= 1
            hearts.last!.removeFromParent()
            hearts.removeLast()

            if archer.lives <= 0 {
                gameState.enterState(GameOverState)
            }
            else {
                archer.hurt()
                archer.state = .Hurt
                archer.physicsBody?.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Heart | PhysicsCategory.IceBlock
                archer.runAction(SKAction(named: "HurtFade")!)
            }
            
            /* Check what kind of object the player made contact with */
            if nodeA.isKindOfClass(MeleeOrc) {
                let orc = nodeA as! MeleeOrc
                orc.hitArcher()
                orc.physicsBody?.categoryBitMask = PhysicsCategory.None

            }
            else if nodeB.isKindOfClass(MeleeOrc) {
                let orc = nodeB as! MeleeOrc
                orc.hitArcher()
                self.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
            else if nodeA.isKindOfClass(Spike) {
                let spike = nodeA as! Spike
                spike.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
            else if nodeB.isKindOfClass(Spike) {
                let spike = nodeB as! Spike
                spike.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
        }
        
        /* Heart - Player contact */
        if categoryA == PhysicsCategory.Heart && categoryB == PhysicsCategory.Player {
            if nodeA.isKindOfClass(Heart) {
                grabHeart(nodeA)
            }
        }
        else if categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Heart {
            if nodeB.isKindOfClass(Heart) {
                grabHeart(nodeB)
            }
        }
        
        /* IceBlock - Player contact */
        if categoryA == PhysicsCategory.IceBlock && categoryB == PhysicsCategory.Player {
            if nodeA.isKindOfClass(Orc) {
                breakiceBlock(nodeA)
            }
        }
        else if categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.IceBlock {
            if nodeB.isKindOfClass(Orc) {
                breakiceBlock(nodeB)
            }
        }
        
        /* Obstacle - Arrow contact */
        if categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Arrow {
            if nodeA.isKindOfClass(MeleeOrc) {
                killOrc(nodeA, nodeArrow: nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Obstacle {
            if nodeB.isKindOfClass(MeleeOrc) {
                killOrc(nodeB, nodeArrow: nodeA)
            }
        }
        
        /* Coin - Player contact */
        if categoryA == PhysicsCategory.Coin || categoryB == PhysicsCategory.Coin {
            if nodeA.isKindOfClass(Coin) {
                grabCoin(nodeA)
            }
            else if nodeB.isKindOfClass(Coin) {
                grabCoin(nodeB)
            }
        }
        
        /* Target - Arrow contact */
        if categoryA == PhysicsCategory.Target && categoryB == PhysicsCategory.Arrow {
            if nodeA.isKindOfClass(Target) {
                hitTargetWithSpikes(nodeA, nodeArrow: nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Target {
            if nodeB.isKindOfClass(Target) {
                hitTargetWithSpikes(nodeB, nodeArrow: nodeA)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if gameState.currentState is GameOverState || gameState.currentState is StartingState { return }
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        if location?.x < (frame.width / 2) / 2 {
            // make the hero jump
            if archer.state == .DoubleJumping || archer.state == .HurtDoubleJump { return }
            
            if gameState.currentState is TutorialState { didTutJump = true }
            
            if archer.state == .Jumping || archer.state == .HurtJump {
                archer.doubleJump()
            }
            else {
                archer.jump()
            }
        }
        else {
            if arrowTimer < 0.4 {
                return
            }
            
            let touchLocation = touch!.locationInNode(self)
            
            let swipe = CGVector(dx: archer.position.x - touchLocation.x, dy: archer.position.y - touchLocation.y)
            let mag = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
            
            let arrowDx = -swipe.dx / mag
            let arrowDy = -swipe.dy / mag
            
            archer.shootArrowAnimation()
            
            let arrow = Arrow()
            addChild(arrow)
            arrows.append(arrow)
            arrow.position = archer.position + CGPoint(x: 10, y: -10)
            arrow.physicsBody?.applyImpulse(CGVector(dx: arrowDx * 6.5, dy: arrowDy * 10))
            if gameState.currentState is TutorialState { didTutShoot = true }
            ChallengeManager.sharedInstance.shotArrow()
            
            arrowTimer = 0
        }
    }
   
    override func update(currentTime: NSTimeInterval) {
        /* Update states with deltaTime */
        deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 {
            deltaTime = 1.0 / 60.0
            lastUpdateTime = currentTime
        }
        gameState.updateWithDeltaTime(deltaTime)
        
        /* Scroll water to make it look animated */
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
        
        /* Manage active arrows on scene */
        checkForArrowOutOfBounds()
        
        if archer.state == .Hurt || archer.state == .HurtJump || archer.state == .HurtDoubleJump {
            hurtTimer += deltaTime
            if hurtTimer >= 1.25 {
                archer.run()
                archer.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin | PhysicsCategory.Heart | PhysicsCategory.IceBlock
                hurtTimer = 0
                archer.removeActionForKey("HurtFade")
            }
        }
        
        arrowTimer += deltaTime
    }
    
    func checkForArrowOutOfBounds() {
        for arrow in arrows {
            if arrow.position.y < 0 || arrow.position.x < 0{
                let index = arrows.indexOf(arrow)!
                arrows.removeAtIndex(index)
                arrow.removeFromParent()
            }
        }
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func grabCoin(node: SKNode) {
        let coin = node as! Coin
        
        coin.removeFromParent()
        
        coinCount += 1
        
        ChallengeManager.sharedInstance.collectedCoin()
    }
    
    func killOrc(nodeOrc: SKNode, nodeArrow: SKNode) {
        let orc = nodeOrc as! MeleeOrc
        let arrow = nodeArrow as! Arrow
        
        if arrow.type == .Ice {
            orc.freeze()
        }
        else if arrow.type == .Fire {
            orc.die()
            orc.burn()
        }
        else if arrow.type == .Explosive {
            orc.physicsBody!.applyImpulse(CGVector(dx: 30, dy: 30))

            
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.zPosition = orc.zPosition + 1
            explosion.position = orc.parent!.convertPoint(orc.position, toNode: obstacleScrollLayer)
            obstacleScrollLayer.addChild(explosion)

            let wait = SKAction.waitForDuration(0.8)
            let removeExplosion = SKAction.runBlock({ explosion.removeFromParent() })
            
            let sequence = SKAction.sequence([wait, removeExplosion])
            
            runAction(sequence)
            
            orc.die()
        }
        else {
            orc.die()
        }
        
        //Remove arrow from parent
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        self.runAction(removeArrow)
        
        arrows.removeAtIndex(arrows.indexOf(arrow)!)
        
        let removeAndAddOrc = SKAction.runBlock({
            orc.position = orc.parent!.convertPoint(orc.position, toNode: self.obstacleScrollLayer)
            orc.removeFromParent()
            self.obstacleScrollLayer.addChild(orc)
        })
        
        self.runAction(removeAndAddOrc)
        
        
        ChallengeManager.sharedInstance.killedOrc()
    }
    
    func hitTargetWithSpikes(node: SKNode, nodeArrow: SKNode) {
        let target = node as! Target
        let arrow = nodeArrow as! Arrow
        
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        if arrow.type == .Ice {
            target.freeze()
            self.runAction(removeArrow)
        }
        
        for case let spike as Spike in target.children {
            let slideDown = SKAction.moveBy(CGVector(dx: 0, dy: -spike.size.height), duration: 0.25)
            let removeSpike = SKAction.runBlock({ spike.removeFromParent() })
            
            let slideAndRemove = SKAction.sequence([slideDown, removeSpike])
            
            spike.zPosition = -1
            spike.runAction(slideAndRemove)
        }
        
        target.gotHit()
        
        ChallengeManager.sharedInstance.hitTarget()
    }
    
    func setupGroundPhysics() {
        startGroundLarge.physicsBody = SKPhysicsBody(texture: startGroundLarge!.texture!, size: startGroundLarge.size)
        startGroundLarge.physicsBody?.affectedByGravity = false
        startGroundLarge.physicsBody?.dynamic = false
        startGroundLarge.physicsBody?.restitution = 0
        startGroundLarge.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        startGroundLarge.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        startGroundLarge.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder1.physicsBody = SKPhysicsBody(texture: levelHolder1!.texture!, size: levelHolder1.size)
        levelHolder1.physicsBody?.affectedByGravity = false
        levelHolder1.physicsBody?.dynamic = false
        levelHolder1.physicsBody?.restitution = 0
        levelHolder1.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder1.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        levelHolder1.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder2.physicsBody = SKPhysicsBody(texture: levelHolder2!.texture!, size: levelHolder2.size)
        levelHolder2.physicsBody?.affectedByGravity = false
        levelHolder2.physicsBody?.dynamic = false
        levelHolder2.physicsBody?.restitution = 0
        levelHolder2.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder2.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        levelHolder2.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        invisibleGround.physicsBody = SKPhysicsBody(rectangleOfSize: invisibleGround.size)
        invisibleGround.physicsBody?.affectedByGravity = false
        invisibleGround.physicsBody?.dynamic = false
        invisibleGround.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        invisibleGround.physicsBody?.contactTestBitMask = PhysicsCategory.None
        invisibleGround.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
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
    
    func breakiceBlock(orcNode: SKNode) {
        let orc = orcNode as! Orc
        
        let particles = SKEmitterNode(fileNamed: "IceExplosion")!
        particles.position = orc.position
        
        let removeOrc = SKAction.runBlock({ orc.removeFromParent() })
        let addParticles = SKAction.runBlock({ self.obstacleScrollLayer.addChild(particles) })
        let wait = SKAction.waitForDuration(2.5)
        let removeParticles = SKAction.runBlock({ particles.removeFromParent() })
        
        let sequence = SKAction.sequence([removeOrc, addParticles, wait, removeParticles])
        
        runAction(sequence)
    }
    
    func addHeart() {
        let heartTexture = SKTexture(imageNamed: "heartFinal")
        let newHeart = SKSpriteNode(texture: heartTexture, color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
        if hearts.isEmpty {
            newHeart.position = CGPointMake(622, 380)
            hearts.append(newHeart)
            addChild(newHeart)
        }
        else {
            newHeart.position = hearts.last!.position + CGPoint(x: 38, y: 0)
            hearts.append(newHeart)
            addChild(newHeart)
        }
    }
    
    func grabHeart(heartNode: SKNode) {
        let heart = heartNode as! Heart
        
        let heartExplosion = SKEmitterNode(fileNamed: "HeartExplosion")!
        heartExplosion.position = heart.position
        
        let removeHeart = SKAction.runBlock({ heart.removeFromParent() })
        let addParticles = SKAction.runBlock({ self.obstacleScrollLayer.addChild(heartExplosion) })
        let wait = SKAction.waitForDuration(1.5)
        let removeParticles = SKAction.runBlock({ heartExplosion.removeFromParent() })
        
        let sequence = SKAction.sequence([removeHeart, addParticles, wait, removeParticles])
        
        runAction(sequence)
        
        if archer.lives >= 2 {
            return
        }
        
        archer.lives += 1
        addHeart()
    }
    
    func selectedRowNode(node: SKSpriteNode) {
        // Check the node name to decide what to do here...
        if let name = node.name {
            if name == "close" {
                list.removeFromParent()
                return
            }
            
            let isEquipped = Arrow.isEquipped(name)
            let isBought: Bool = availableArrows[name]!
            let parent = node.parent!
            
            if !isBought {
                //get player's money count
                var totalCoinCount = userDefaults.integerForKey("totalCoins")
                //get cost of arrow
                let coinLabel = parent.childNodeWithName("coinLabel") as! SKLabelNode
                let coinCost = Int(coinLabel.text!)!
                //check if player can buy arrow
                if totalCoinCount > coinCost {
                    //remove cost of arrow from player money
                    totalCoinCount -= coinCost
                    //save totalCoinCount
                    userDefaults.setValue(totalCoinCount, forKey: "totalCoins")
                    //update coin count label
                    totalCoinCountLabel.text = String(totalCoinCount)
                    //update availableArrows dict
                    availableArrows[name] = true
                    userDefaults.setObject(availableArrows, forKey: "availableArrows")
                    userDefaults.synchronize()
                    //get node elements
                    let coinSprite = parent.childNodeWithName("coinSprite") as! SKSpriteNode
                    let buyLabel = parent.childNodeWithName("buyLabel") as! SKLabelNode
                    //modify node elements
                    coinLabel.removeFromParent()
                    coinSprite.removeFromParent()
                    buyLabel.text = "EQUIP"
                }
                else {
                    //fade or change color animation in buy label
                }
            }
            else {
                if !isEquipped {
                    Arrow.setEquippedTypeFromRawValue(name)
                }
                list.removeFromParent()
                return
            }
        }
    }
    
    func setupList() {
        list.delegate = self
        // Add the list to this scene
        addChild(list)
        // Position the list. THe reference point is in the center.
        list.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        for (key, value) in availableArrows {
            if value {
                let isEquipped = Arrow.isEquipped(key)
                createArrowRow(key, cost: 1000, isBought: value, isEquipped: isEquipped)
            }
            else {
                createArrowRow(key, cost: 1000, isBought: false, isEquipped: false)
            }
        }
        
        let row = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: list.size.width, height: 60))
        row.name = "close"
        
        let rowOverlay = SKSpriteNode(color: UIColor.clearColor(), size: row.size)
        rowOverlay.name = "close"
        rowOverlay.zPosition = 151
        row.addChild(rowOverlay)
        
        let closeLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        closeLabel.text = "CLOSE"
        closeLabel.fontColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        row.addChild(closeLabel)
        closeLabel.position = CGPoint(x: 0, y: 0)
        
        list.addNode(row)
    }
    
    func createArrowRow(name: String, cost: Int, isBought: Bool, isEquipped: Bool) {
        let rowColor = UIColor(red: 163/255, green: 134/255, blue: 113/255, alpha: 1)
        let row = SKSpriteNode(color: rowColor, size: CGSize(width: list.size.width, height: 60))
        row.name = name
        
        let rowOverlay = SKSpriteNode(color: UIColor.clearColor(), size: row.size)
        rowOverlay.name = name
        rowOverlay.zPosition = 151
        row.addChild(rowOverlay)
        
        var arrowTexture: SKTexture!
        var titleText: String!
        
        if name == "regular" {
            arrowTexture = SKTexture(imageNamed: "arrow")
            titleText = "Regular Arrow"
        }
        else if name == "ice" {
            arrowTexture = SKTexture(imageNamed: "arrowIce")
            titleText = "Ice Arrow"
        }
        else if name == "fire" {
            arrowTexture = SKTexture(imageNamed: "arrowFire")
            titleText = "Fire Arrow"
        }
        else if name == "explosive" {
            arrowTexture = SKTexture(imageNamed: "arrowExplosive")
            titleText = "Explosive Arrow"
        }
        
        let arrowSprite = SKSpriteNode(texture: arrowTexture, color: UIColor.clearColor(), size: CGSize(width: 62, height: 10))
        row.addChild(arrowSprite)
        arrowSprite.position = CGPoint(x: -290, y: -4)
        
        let titleLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        titleLabel.text = titleText
        titleLabel.fontSize = 32
        titleLabel.horizontalAlignmentMode = .Left
        row.addChild(titleLabel)
        titleLabel.position.x = arrowSprite.position.x + 50
        titleLabel.position.y = -2
        
        if !isBought {
            let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clearColor(), size: CGSize(width: 21, height: 21))
            coinSprite.name = "coinSprite"
            row.addChild(coinSprite)
            coinSprite.position = CGPoint(x: -230, y: -18.5)
            
            let coinLabel = SKLabelNode(fontNamed: "Courier New")
            coinLabel.name = "coinLabel"
            coinLabel.text = String(cost)
            coinLabel.fontSize = 24
            coinLabel.horizontalAlignmentMode = .Left
            row.addChild(coinLabel)
            coinLabel.position = CGPoint(x: -220, y: -27)
        }
        
        let buyLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        buyLabel.name = "buyLabel"
        buyLabel.fontSize = 24
        row.addChild(buyLabel)
        buyLabel.position = CGPoint(x: 196, y: -5)
        
        if !isBought {
            buyLabel.text = "TAP TO BUY"
        }
        else {
            if isEquipped {
                buyLabel.text = "EQUIPPED"
            }
            else {
                buyLabel.text = "EQUIP"
            }
        }
        
        list.addNode(row)
    }
}