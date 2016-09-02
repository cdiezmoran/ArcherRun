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

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GKStateMachine!
    var gameOverState: GKState!
    var pauseState: GKState!
    var playingState: GKState!
    var startingState: GKState!
    var tutorialState: GKState!
    var bossState: GKState!
    var challengeCompletedState: GKState!
    var extraChanceState: GKState!
    
    var arrows: [Arrow] = []
    var arrowTimer: CFTimeInterval = 0.4
    var availableArrows = [String:Bool]()
    var backgroundMusic: SKAudioNode!
    var didCompleteChallenge: Bool = false
    var didGetExtraChance: Bool = false
    var challengeIcons = [SKSpriteNode]()
    var coinCount: Int = 0 {
        didSet {
            coinCountLabel.text = String(coinCount)
        }
    }
    var currentLevelHolder: String = "levelHolder1"
    var deltaTime: Double!
    var didTutJump: Bool = false
    var didTutShoot: Bool = false
    var firstTouchLocation = CGPointZero
    var floorSpeed: CGFloat = 4
    var hearts = [SKSpriteNode]()
    var hurtTimer: CFTimeInterval = 0
    var intervalMin: CGFloat = 0.5
    var intervalMax:CGFloat = 1.5
    var lastRoundedScore: Int = 0
    var lastUpdateTime: CFTimeInterval = 0
    var leaderboardsAreOpen: Bool = false
    var musicIsOn: Bool!
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
    var shopIndex: Int = 0
    var soundsAreOn: Bool!
    var timer: CFTimeInterval = 0
    var userDefaults: NSUserDefaults!
    var undead: Undead!
    var undeadHealthBar: SKSpriteNode!
    
    var archer: Archer!
    var challengeActiveBanner: SKSpriteNode!
    var challengeActiveLabel: SKLabelNode!
    var challengeActiveProgress: SKLabelNode!
    var challengeCompletedBanner: SKSpriteNode!
    var challengeCompletedIcon: SKSpriteNode!
    var challengeCompletedIconBG: SKSpriteNode!
    var challengeCompletedLabel: SKLabelNode!
    var challengeCompletedScreen: SKSpriteNode!
    var challengeHolder: SKSpriteNode!
    var challengeIcon: SKSpriteNode!
    var challengeIconBG: SKSpriteNode!
    var challengeLabel: SKLabelNode!
    var clouds: SKEmitterNode!
    var coinCountLabel: SKLabelNode!
    var coinRewardLabel: SKLabelNode!
    var completedSprite: SKSpriteNode!
    var enemyScrollLayer: SKNode!
    var enemyScrollLayerFast: SKNode!
    var enemyScrollLayerSlow: SKNode!
    var firstChallengeHolder: SKSpriteNode!
    var firstChallengeLabel: SKLabelNode!
    var firstChallengeIcon: SKSpriteNode!
    var firstChallengeIconBG: SKSpriteNode!
    var firstProgressLabel: SKLabelNode!
    var gameOverScreen: SKSpriteNode!
    var highScoreLabel: SKLabelNode!
    var invisibleGround: SKSpriteNode!
    var leaderboardsButton: MSButtonNode!
    var leaderboardsScreen: SKSpriteNode!
    var levelHolder1: SKSpriteNode!
    var levelHolder2: SKSpriteNode!
    var levelInfoHolder: SKSpriteNode!
    var levelLabel: SKLabelNode!
    var levelProgressBar: SKSpriteNode!
    var mountains1: SKSpriteNode!
    var mountains2: SKSpriteNode!
    var musicOff: MSButtonNode!
    var musicOn: MSButtonNode!
    var obstacleScrollLayer: SKNode!
    var pauseButton: MSButtonNode!
    var pauseScreen: SKSpriteNode!
    var playAgainButton: MSButtonNode!
    var playButton: MSButtonNode!
    var retryButton: MSButtonNode!
    var startGroundLarge: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var scoreLabelGO: SKLabelNode!
    var secondChallengeHolder: SKSpriteNode!
    var secondChallengeLabel: SKLabelNode!
    var secondChallengeIcon: SKSpriteNode!
    var secondChallengeIconBG: SKSpriteNode!
    var secondProgressLabel: SKLabelNode!
    var shopButton: MSButtonNode!
    var soundsOff: MSButtonNode!
    var soundsOn: MSButtonNode!
    var startMountains: SKSpriteNode!
    var startingScrollLayer: SKNode!
    var startTreesBack: SKSpriteNode!
    var startTreesFront: SKSpriteNode!
    var thirdChallengeHolder: SKSpriteNode!
    var thirdChallengeLabel: SKLabelNode!
    var thirdChallengeIcon: SKSpriteNode!
    var thirdChallengeIconBG: SKSpriteNode!
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
        
        challengeActiveBanner = self.childNodeWithName("challengeActiveBanner") as! SKSpriteNode
        challengeActiveLabel = self.childNodeWithName("//challengeActiveLabel") as! SKLabelNode
        challengeActiveProgress = self.childNodeWithName("//challengeActiveProgress") as! SKLabelNode
        challengeCompletedBanner = self.childNodeWithName("challengeCompletedBanner") as! SKSpriteNode
        challengeCompletedIcon = self.childNodeWithName("//challengeCompletedIcon") as! SKSpriteNode
        challengeCompletedIconBG = self.childNodeWithName("//challengeCompletedIconBG") as! SKSpriteNode
        challengeCompletedLabel = self.childNodeWithName("//challengeCompletedLabel") as! SKLabelNode
        challengeCompletedScreen = self.childNodeWithName("//challengeCompletedScreen") as! SKSpriteNode
        challengeHolder = self.childNodeWithName("challengeHolder") as! SKSpriteNode
        challengeIcon = self.childNodeWithName("//challengeIcon") as! SKSpriteNode
        challengeIconBG = self.childNodeWithName("//challengeIconBG") as! SKSpriteNode
        challengeLabel = self.childNodeWithName("//challengeLabel") as! SKLabelNode
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        coinCountLabel = self.childNodeWithName("coinCountLabel") as! SKLabelNode
        coinRewardLabel = self.childNodeWithName("//coinRewardLabel") as! SKLabelNode
        completedSprite = self.childNodeWithName("//completedSprite") as! SKSpriteNode
        enemyScrollLayer = self.childNodeWithName("enemyScrollLayer")
        enemyScrollLayerFast = self.childNodeWithName("enemyScrollLayerFast")
        enemyScrollLayerSlow = self.childNodeWithName("enemyScrollLayerSlow")
        firstChallengeHolder = self.childNodeWithName("//firstChallengeHolder") as! SKSpriteNode
        firstChallengeLabel = self.childNodeWithName("//firstChallengeLabel") as! SKLabelNode
        firstChallengeIcon = self.childNodeWithName("//firstChallengeIcon") as! SKSpriteNode
        firstChallengeIconBG = self.childNodeWithName("//firstChallengeIconBG") as! SKSpriteNode
        firstProgressLabel = self.childNodeWithName("//firstProgressLabel") as! SKLabelNode
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        highScoreLabel = self.childNodeWithName("//highScoreLabel") as! SKLabelNode
        invisibleGround = self.childNodeWithName("//invisibleGround") as! SKSpriteNode
        leaderboardsButton = self.childNodeWithName("//leaderboardsButton") as! MSButtonNode
        leaderboardsScreen = self.childNodeWithName("//leaderboardsScreen") as! SKSpriteNode
        levelHolder1 = self.childNodeWithName("levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNodeWithName("levelHolder2") as! SKSpriteNode
        levelInfoHolder = self.childNodeWithName("//levelInfoHolder") as! SKSpriteNode
        levelLabel = self.childNodeWithName("//levelLabel") as! SKLabelNode
        levelProgressBar = self.childNodeWithName("//levelProgressBar") as! SKSpriteNode
        mountains1 = self.childNodeWithName("mountains1") as! SKSpriteNode
        mountains2 = self.childNodeWithName("mountains2") as! SKSpriteNode
        musicOff = self.childNodeWithName("//musicOff") as! MSButtonNode
        musicOn = self.childNodeWithName("//musicOn") as! MSButtonNode
        obstacleScrollLayer = self.childNodeWithName("obstacleScrollLayer")
        pauseButton = self.childNodeWithName("pauseButton") as! MSButtonNode
        pauseScreen = self.childNodeWithName("pauseScreen") as! SKSpriteNode
        playAgainButton = self.childNodeWithName("//playAgainButton") as! MSButtonNode
        playButton = self.childNodeWithName("//playButton") as! MSButtonNode
        retryButton = self.childNodeWithName("//retryButton") as! MSButtonNode
        startGroundLarge = self.childNodeWithName("//startGroundLarge") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabelGO = self.childNodeWithName("//scoreLabelGO") as! SKLabelNode
        secondChallengeHolder = self.childNodeWithName("//secondChallengeHolder") as! SKSpriteNode
        secondChallengeLabel = self.childNodeWithName("//secondChallengeLabel") as! SKLabelNode
        secondChallengeIcon = self.childNodeWithName("//secondChallengeIcon") as! SKSpriteNode
        secondChallengeIconBG = self.childNodeWithName("//secondChallengeIconBG") as! SKSpriteNode
        secondProgressLabel = self.childNodeWithName("//secondProgressLabel") as! SKLabelNode
        shopButton = self.childNodeWithName("//shopButton") as! MSButtonNode
        soundsOff = self.childNodeWithName("//soundsOff") as! MSButtonNode
        soundsOn = self.childNodeWithName("//soundsOn") as! MSButtonNode
        startMountains = self.childNodeWithName("startMountains") as! SKSpriteNode
        startingScrollLayer = self.childNodeWithName("startingScrollLayer")
        startTreesBack = self.childNodeWithName("startTreesBack") as! SKSpriteNode
        startTreesFront = self.childNodeWithName("startTreesFront") as! SKSpriteNode
        thirdChallengeHolder = self.childNodeWithName("//thirdChallengeHolder") as! SKSpriteNode
        thirdChallengeLabel = self.childNodeWithName("//thirdChallengeLabel") as! SKLabelNode
        thirdChallengeIcon = self.childNodeWithName("//thirdChallengeIcon") as! SKSpriteNode
        thirdChallengeIconBG = self.childNodeWithName("//thirdChallengeIconBG") as! SKSpriteNode
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
        pauseScreen.hidden = true
        soundsOn.hidden = true
        soundsOff.hidden = true
        musicOn.hidden = true
        musicOff.hidden = true
        
        setupGroundPhysics()
        
        gameOverState = GameOverState(scene: self)
        pauseState = PauseState(scene: self)
        playingState = PlayingState(scene: self)
        startingState = StartingState(scene: self)
        tutorialState = TutorialState(scene: self)
        bossState = BossState(scene: self)
        challengeCompletedState = ChallengeCompletedState(scene: self)
        extraChanceState = ExtraChanceState(scene: self)
        
        gameState = GKStateMachine(states: [startingState, pauseState, playingState, gameOverState, tutorialState, bossState, challengeCompletedState, extraChanceState])
        
        randomInterval = CGFloat.random(min: 0.3, max: 1)
        
        setButtonHandlers()
        
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
        
        soundsAreOn = userDefaults.boolForKey("soundsSettings")
        musicIsOn = userDefaults.boolForKey("musicSettings")
        
        if musicIsOn! {
            playBackgroundMusic()
        }
        
        setMusicAndSoundHandlers()
        
        setChallengeLabels()
        setProgressLabels()
        levelLabel.text = String(Int(LevelManager.sharedInstance.level))
        levelProgressBar.xScale = LevelManager.sharedInstance.getProgressBarXScale()
        
        addHeart()
        addHeart()
        
        showChallengesAtGameStart()
        
        loadAds()
        
        //Enter first State
        gameState.enterState(StartingState)
        
        //Observer to pause game when ad is clicked
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(GameScene.pauseGame),
            name: "pauseGame",
            object: nil)
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
            
            if archer.state == .DoubleJumping || archer.state == .HurtDoubleJump {
                archer.resetRotation()
            }
            
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
                archer.resetRotation()
                archer.die()
                //Go to ExtraChanceState
                if !didGetExtraChance {
                    gameState.enterState(ExtraChanceState)
                }
                else {
                    if didCompleteChallenge {
                        gameState.enterState(ChallengeCompletedState)
                    }
                    else {
                        gameState.enterState(GameOverState)
                    }
                }
            }
            else {
                archer.hurt()
                archer.state = .Hurt
                archer.physicsBody?.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Heart | PhysicsCategory.IceBlock
                archer.runAction(SKAction(named: "HurtFade")!, withKey: "hurtAnimation")
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
            else if nodeA.isKindOfClass(Undead) {
                hitUndead(nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Obstacle {
            if nodeB.isKindOfClass(MeleeOrc) {
                killOrc(nodeB, nodeArrow: nodeA)
            }
            else if nodeB.isKindOfClass(Undead) {
                hitUndead(nodeA)
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
        if gameState.currentState is GameOverState || gameState.currentState is StartingState || gameState.currentState is ChallengeCompletedState || gameState.currentState is ExtraChanceState { return }
        
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
            playShootArrowSound()
            if gameState.currentState is TutorialState { didTutShoot = true }
            ChallengeManager.sharedInstance.shotArrow()
            
            arrowTimer = 0
        }
    }
   
    override func update(currentTime: NSTimeInterval) {
        if gameState.currentState is PauseState {
            return
        }
        
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
                archer.removeActionForKey("hurtAnimation")
                archer.alpha = 1
                
                if archer.state == .HurtJump {
                    archer.state = .Jumping
                }
                else if archer.state == .HurtDoubleJump {
                    archer.state = .DoubleJumping
                }
                else {
                  archer.run()  
                }
                
                archer.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin | PhysicsCategory.Heart | PhysicsCategory.IceBlock
                hurtTimer = 0
            }
        }
        
        removeObstacles()
        
        arrowTimer += deltaTime
    }
    
    func setButtonHandlers() {
        playAgainButton.selectedHandler = {
            self.loadGameScene()
        }
        shopButton.selectedHandler = {
            self.createShopMenuWindow()
        }
        pauseButton.selectedHandler = {
            self.pauseGame()
        }
        playButton.selectedHandler = {
            self.gameState.enterState(PlayingState)
            
            self.pauseScreen.hidden = true
            
            self.musicOn.hidden = true
            self.musicOff.hidden = true
            self.soundsOn.hidden = true
            self.soundsOff.hidden = true
        }
        retryButton.selectedHandler = {
            self.loadGameScene()
        }
        setLeaderboardsSelectedHandler()
    }
    
    func loadGameScene() {
        NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            skView.presentScene(scene)
        }
    }
    
    func setLeaderboardsSelectedHandler() {
        if leaderboardsAreOpen {
            leaderboardsButton.selectedHandler = {
                let hideAction = SKAction.moveToX(-595, duration: 0.5)
                self.leaderboardsScreen.runAction(hideAction)
                
                self.leaderboardsAreOpen = false
                self.setLeaderboardsSelectedHandler()
            }
        }
        else {
            leaderboardsButton.selectedHandler = {
                let showAction = SKAction.moveToX(-141, duration: 0.5)
                self.leaderboardsScreen.runAction(showAction)
                
                self.leaderboardsAreOpen = true
                self.setLeaderboardsSelectedHandler()
            }
        }
    }
    
    func pauseGame() {
        gameState.enterState(PauseState)
    }
    
    func setupGroundPhysics() {
        startGroundLarge.physicsBody = getFloorPhysicsBody(texture: startGroundLarge!.texture!, size: startGroundLarge.size)
        
        levelHolder1.physicsBody = getFloorPhysicsBody(texture: levelHolder1!.texture!, size: levelHolder1.size)
        
        levelHolder2.physicsBody = getFloorPhysicsBody(texture: levelHolder2!.texture!, size: levelHolder2.size)
        
        invisibleGround.physicsBody = SKPhysicsBody(rectangleOfSize: invisibleGround.size)
        invisibleGround.physicsBody?.affectedByGravity = false
        invisibleGround.physicsBody?.dynamic = false
        invisibleGround.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        invisibleGround.physicsBody?.contactTestBitMask = PhysicsCategory.None
        invisibleGround.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
    func getFloorPhysicsBody(texture texture: SKTexture, size: CGSize) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, size: size)
        
        body.affectedByGravity = false
        body.dynamic = false
        body.restitution = 0
        body.categoryBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Player
        body.collisionBitMask = PhysicsCategory.Player
        
        return body
    }
    
    func loadAds() {
        //Call observer
        NSNotificationCenter.defaultCenter().postNotificationName("loadAds", object: nil)
    }
    
    func clearObstacles() {
        removeChildrenOfNode(obstacleScrollLayer)
        removeChildrenOfNode(enemyScrollLayer)
        removeChildrenOfNode(enemyScrollLayerFast)
        removeChildrenOfNode(enemyScrollLayerSlow)
    }
    
    func removeChildrenOfNode(node: SKNode) {
        for child in node.children {
            child.removeFromParent()
        }
    }
}
