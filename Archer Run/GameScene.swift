//
//  GameScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
    var availableCharacters = [String: Bool]()
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
    var didRecieveRewardAd: Bool = false
    var didTutJump: Bool = false
    var didTutShoot: Bool = false
    var firstTouchLocation = CGPoint.zero
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
    var userDefaults: UserDefaults!
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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        archer = Archer()
        addChild(archer)
        
        challengeActiveBanner = self.childNode(withName: "challengeActiveBanner") as! SKSpriteNode
        challengeActiveLabel = self.childNode(withName: "//challengeActiveLabel") as! SKLabelNode
        challengeActiveProgress = self.childNode(withName: "//challengeActiveProgress") as! SKLabelNode
        challengeCompletedBanner = self.childNode(withName: "challengeCompletedBanner") as! SKSpriteNode
        challengeCompletedIcon = self.childNode(withName: "//challengeCompletedIcon") as! SKSpriteNode
        challengeCompletedIconBG = self.childNode(withName: "//challengeCompletedIconBG") as! SKSpriteNode
        challengeCompletedLabel = self.childNode(withName: "//challengeCompletedLabel") as! SKLabelNode
        challengeCompletedScreen = self.childNode(withName: "//challengeCompletedScreen") as! SKSpriteNode
        challengeHolder = self.childNode(withName: "challengeHolder") as! SKSpriteNode
        challengeIcon = self.childNode(withName: "//challengeIcon") as! SKSpriteNode
        challengeIconBG = self.childNode(withName: "//challengeIconBG") as! SKSpriteNode
        challengeLabel = self.childNode(withName: "//challengeLabel") as! SKLabelNode
        clouds = self.childNode(withName: "clouds") as! SKEmitterNode
        coinCountLabel = self.childNode(withName: "coinCountLabel") as! SKLabelNode
        coinRewardLabel = self.childNode(withName: "//coinRewardLabel") as! SKLabelNode
        completedSprite = self.childNode(withName: "//completedSprite") as! SKSpriteNode
        enemyScrollLayer = self.childNode(withName: "enemyScrollLayer")
        enemyScrollLayerFast = self.childNode(withName: "enemyScrollLayerFast")
        enemyScrollLayerSlow = self.childNode(withName: "enemyScrollLayerSlow")
        firstChallengeHolder = self.childNode(withName: "//firstChallengeHolder") as! SKSpriteNode
        firstChallengeLabel = self.childNode(withName: "//firstChallengeLabel") as! SKLabelNode
        firstChallengeIcon = self.childNode(withName: "//firstChallengeIcon") as! SKSpriteNode
        firstChallengeIconBG = self.childNode(withName: "//firstChallengeIconBG") as! SKSpriteNode
        firstProgressLabel = self.childNode(withName: "//firstProgressLabel") as! SKLabelNode
        gameOverScreen = self.childNode(withName: "gameOverScreen") as! SKSpriteNode
        highScoreLabel = self.childNode(withName: "//highScoreLabel") as! SKLabelNode
        invisibleGround = self.childNode(withName: "//invisibleGround") as! SKSpriteNode
        leaderboardsButton = self.childNode(withName: "//leaderboardsButton") as! MSButtonNode
        leaderboardsScreen = self.childNode(withName: "//leaderboardsScreen") as! SKSpriteNode
        levelHolder1 = self.childNode(withName: "levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNode(withName: "levelHolder2") as! SKSpriteNode
        levelInfoHolder = self.childNode(withName: "//levelInfoHolder") as! SKSpriteNode
        levelLabel = self.childNode(withName: "//levelLabel") as! SKLabelNode
        levelProgressBar = self.childNode(withName: "//levelProgressBar") as! SKSpriteNode
        mountains1 = self.childNode(withName: "mountains1") as! SKSpriteNode
        mountains2 = self.childNode(withName: "mountains2") as! SKSpriteNode
        musicOff = self.childNode(withName: "//musicOff") as! MSButtonNode
        musicOn = self.childNode(withName: "//musicOn") as! MSButtonNode
        obstacleScrollLayer = self.childNode(withName: "obstacleScrollLayer")
        pauseButton = self.childNode(withName: "pauseButton") as! MSButtonNode
        pauseScreen = self.childNode(withName: "pauseScreen") as! SKSpriteNode
        playAgainButton = self.childNode(withName: "//playAgainButton") as! MSButtonNode
        playButton = self.childNode(withName: "//playButton") as! MSButtonNode
        retryButton = self.childNode(withName: "//retryButton") as! MSButtonNode
        startGroundLarge = self.childNode(withName: "//startGroundLarge") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabelGO = self.childNode(withName: "//scoreLabelGO") as! SKLabelNode
        secondChallengeHolder = self.childNode(withName: "//secondChallengeHolder") as! SKSpriteNode
        secondChallengeLabel = self.childNode(withName: "//secondChallengeLabel") as! SKLabelNode
        secondChallengeIcon = self.childNode(withName: "//secondChallengeIcon") as! SKSpriteNode
        secondChallengeIconBG = self.childNode(withName: "//secondChallengeIconBG") as! SKSpriteNode
        secondProgressLabel = self.childNode(withName: "//secondProgressLabel") as! SKLabelNode
        shopButton = self.childNode(withName: "//shopButton") as! MSButtonNode
        soundsOff = self.childNode(withName: "//soundsOff") as! MSButtonNode
        soundsOn = self.childNode(withName: "//soundsOn") as! MSButtonNode
        startMountains = self.childNode(withName: "startMountains") as! SKSpriteNode
        startingScrollLayer = self.childNode(withName: "startingScrollLayer")
        startTreesBack = self.childNode(withName: "startTreesBack") as! SKSpriteNode
        startTreesFront = self.childNode(withName: "startTreesFront") as! SKSpriteNode
        thirdChallengeHolder = self.childNode(withName: "//thirdChallengeHolder") as! SKSpriteNode
        thirdChallengeLabel = self.childNode(withName: "//thirdChallengeLabel") as! SKLabelNode
        thirdChallengeIcon = self.childNode(withName: "//thirdChallengeIcon") as! SKSpriteNode
        thirdChallengeIconBG = self.childNode(withName: "//thirdChallengeIconBG") as! SKSpriteNode
        thirdProgressLabel = self.childNode(withName: "//thirdProgressLabel") as! SKLabelNode
        totalCoinCountLabel = self.childNode(withName: "//totalCoinCountLabel") as! SKLabelNode
        treesBack1 = self.childNode(withName: "treesBack1") as! SKSpriteNode
        treesBack2 = self.childNode(withName: "treesBack2") as! SKSpriteNode
        treesFront1 = self.childNode(withName: "treesFront1") as! SKSpriteNode
        treesFront2 = self.childNode(withName: "treesFront2") as! SKSpriteNode
        water = self.childNode(withName: "//water") as! SKSpriteNode
        water2 = self.childNode(withName: "//water2") as! SKSpriteNode
        
        clouds.advanceSimulationTime(320)
        
        coinRewardLabel.isHidden = true
        pauseScreen.isHidden = true
        soundsOn.isHidden = true
        soundsOff.isHidden = true
        musicOn.isHidden = true
        musicOff.isHidden = true
        
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
        
        userDefaults = UserDefaults.standard
        playedGames = userDefaults.integer(forKey: "playedGames")
        
        soundsAreOn = userDefaults.bool(forKey: "soundsSettings")
        musicIsOn = userDefaults.bool(forKey: "musicSettings")
        
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
        gameState.enter(StartingState.self)
        
        //Observer to pause game when ad is clicked
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameScene.pauseGame),
            name: NSNotification.Name(rawValue: "pauseGame"),
            object: nil)
        
        //Observer to check if reward ad failed to load
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameScene.receivedRewardAd),
            name: NSNotification.Name(rawValue: "receivedReward"),
            object: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
            
            if archer.state == .hurtJump || archer.state == .hurtDoubleJump {
                archer.state = .hurt
            }
            
            if archer.state == .dead || archer.state == .running || archer.state == .hurt { return }
            
            if archer.state == .doubleJumping || archer.state == .hurtDoubleJump {
                archer.resetRotation()
            }
            
            archer.run()
            
            if gameState.currentState is StartingState {
                if playedGames < 3 {
                    gameState.enter(TutorialState.self)
                }
                else {
                    gameState.enter(PlayingState.self)
                }
            }
        }
        
        /* Player contact with obstacle */
        if (categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Obstacle) {
            if archer.state == .hurt || archer.state == .hurtJump || archer.state == .hurtDoubleJump { return }
            
            archer.lives -= 1
            hearts.last!.removeFromParent()
            hearts.removeLast()

            if archer.lives <= 0 {
                archer.resetRotation()
                archer.die()
                //Go to ExtraChanceState
                if !didGetExtraChance && didRecieveRewardAd {
                    gameState.enter(ExtraChanceState.self)
                }
                else {
                    if didCompleteChallenge {
                        gameState.enter(ChallengeCompletedState.self)
                    }
                    else {
                        gameState.enter(GameOverState.self)
                    }
                }
            }
            else {
                archer.hurt()
                archer.state = .hurt
                archer.physicsBody?.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Heart | PhysicsCategory.IceBlock
                archer.run(SKAction(named: "HurtFade")!, withKey: "hurtAnimation")
            }
            
            /* Check what kind of object the player made contact with */
            if nodeA.isKind(of: MeleeOrc.self) {
                let orc = nodeA as! MeleeOrc
                orc.hitArcher()
                orc.physicsBody?.categoryBitMask = PhysicsCategory.None

            }
            else if nodeB.isKind(of: MeleeOrc.self) {
                let orc = nodeB as! MeleeOrc
                orc.hitArcher()
                self.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
            else if nodeA.isKind(of: Spike.self) {
                let spike = nodeA as! Spike
                spike.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
            else if nodeB.isKind(of: Spike.self) {
                let spike = nodeB as! Spike
                spike.physicsBody?.categoryBitMask = PhysicsCategory.None
            }
        }
        
        /* Heart - Player contact */
        if categoryA == PhysicsCategory.Heart && categoryB == PhysicsCategory.Player {
            if nodeA.isKind(of: Heart.self) {
                grabHeart(nodeA)
            }
        }
        else if categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Heart {
            if nodeB.isKind(of: Heart.self) {
                grabHeart(nodeB)
            }
        }
        
        /* IceBlock - Player contact */
        if categoryA == PhysicsCategory.IceBlock && categoryB == PhysicsCategory.Player {
            if nodeA.isKind(of: Orc.self) {
                breakiceBlock(nodeA)
            }
        }
        else if categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.IceBlock {
            if nodeB.isKind(of: Orc.self) {
                breakiceBlock(nodeB)
            }
        }
        
        /* Obstacle - Arrow contact */
        if categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Arrow {
            if nodeA.isKind(of: MeleeOrc.self) {
                killOrc(nodeA, nodeArrow: nodeB)
            }
            else if nodeA.isKind(of: Undead.self) {
                hitUndead(nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Obstacle {
            if nodeB.isKind(of: MeleeOrc.self) {
                killOrc(nodeB, nodeArrow: nodeA)
            }
            else if nodeB.isKind(of: Undead.self) {
                hitUndead(nodeA)
            }
        }
        
        /* Coin - Player contact */
        if categoryA == PhysicsCategory.Coin || categoryB == PhysicsCategory.Coin {
            if nodeA.isKind(of: Coin.self) {
                grabCoin(nodeA)
            }
            else if nodeB.isKind(of: Coin.self) {
                grabCoin(nodeB)
            }
        }
        
        /* Target - Arrow contact */
        if categoryA == PhysicsCategory.Target && categoryB == PhysicsCategory.Arrow {
            if nodeA.isKind(of: Target.self) {
                hitTargetWithSpikes(nodeA, nodeArrow: nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Target {
            if nodeB.isKind(of: Target.self) {
                hitTargetWithSpikes(nodeB, nodeArrow: nodeA)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        if gameState.currentState is GameOverState || gameState.currentState is StartingState || gameState.currentState is ChallengeCompletedState || gameState.currentState is ExtraChanceState { return }
        
        let touch = touches.first
        let location = touch?.location(in: self)
        if location?.x < (frame.width / 2) / 2 {
            // make the hero jump
            if archer.state == .doubleJumping || archer.state == .hurtDoubleJump { return }
            
            if gameState.currentState is TutorialState { didTutJump = true }
            
            if archer.state == .jumping || archer.state == .hurtJump {
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
            
            let touchLocation = touch!.location(in: self)
            
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
   
    override func update(_ currentTime: TimeInterval) {
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
        gameState.update(deltaTime: deltaTime)
        
        /* Scroll water to make it look animated */
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
        
        /* Manage active arrows on scene */
        checkForArrowOutOfBounds()
        
        if archer.state == .hurt || archer.state == .hurtJump || archer.state == .hurtDoubleJump {
            hurtTimer += deltaTime
            if hurtTimer >= 1.25 {
                archer.removeAction(forKey: "hurtAnimation")
                archer.alpha = 1
                
                if archer.state == .hurtJump {
                    archer.state = .jumping
                }
                else if archer.state == .hurtDoubleJump {
                    archer.state = .doubleJumping
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
            self.gameState.enter(PlayingState.self)
            
            self.pauseScreen.isHidden = true
            
            self.musicOn.isHidden = true
            self.musicOff.isHidden = true
            self.soundsOn.isHidden = true
            self.soundsOff.isHidden = true
        }
        retryButton.selectedHandler = {
            self.loadGameScene()
        }
        setLeaderboardsSelectedHandler()
    }
    
    func loadGameScene() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "removeAds"), object: nil)
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            skView.presentScene(scene)
        }
    }
    
    func setLeaderboardsSelectedHandler() {
        if leaderboardsAreOpen {
            leaderboardsButton.selectedHandler = {
                let hideAction = SKAction.moveTo(x: -595, duration: 0.5)
                self.leaderboardsScreen.run(hideAction)
                
                self.leaderboardsAreOpen = false
                self.setLeaderboardsSelectedHandler()
            }
        }
        else {
            leaderboardsButton.selectedHandler = {
                let showAction = SKAction.moveTo(x: -141, duration: 0.5)
                self.leaderboardsScreen.run(showAction)
                
                self.leaderboardsAreOpen = true
                self.setLeaderboardsSelectedHandler()
            }
        }
    }
    
    func pauseGame() {
        gameState.enter(PauseState.self)
    }
    
    func setupGroundPhysics() {
        startGroundLarge.physicsBody = getFloorPhysicsBody(texture: startGroundLarge!.texture!, size: startGroundLarge.size)
        
        levelHolder1.physicsBody = getFloorPhysicsBody(texture: levelHolder1!.texture!, size: levelHolder1.size)
        
        levelHolder2.physicsBody = getFloorPhysicsBody(texture: levelHolder2!.texture!, size: levelHolder2.size)
        
        invisibleGround.physicsBody = SKPhysicsBody(rectangleOf: invisibleGround.size)
        invisibleGround.physicsBody?.affectedByGravity = false
        invisibleGround.physicsBody?.isDynamic = false
        invisibleGround.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        invisibleGround.physicsBody?.contactTestBitMask = PhysicsCategory.None
        invisibleGround.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
    func getFloorPhysicsBody(texture: SKTexture, size: CGSize) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, size: size)
        
        body.affectedByGravity = false
        body.isDynamic = false
        body.restitution = 0
        body.categoryBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Player
        body.collisionBitMask = PhysicsCategory.Player
        
        return body
    }
    
    func loadAds() {
        //Call observer
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadAds"), object: nil)
    }
    
    func clearObstacles() {
        removeChildrenOfNode(obstacleScrollLayer)
        removeChildrenOfNode(enemyScrollLayer)
        removeChildrenOfNode(enemyScrollLayerFast)
        removeChildrenOfNode(enemyScrollLayerSlow)
    }
    
    func removeChildrenOfNode(_ node: SKNode) {
        for child in node.children {
            child.removeFromParent()
        }
    }
    
    func receivedRewardAd() {
        didRecieveRewardAd = true
    }
}
