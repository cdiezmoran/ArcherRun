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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GKStateMachine!
    var gameOverState: GKState!
    var playingState: GKState!
    var startingState: GKState!
    var tutorialState: GKState!
    
    var arrows: [Arrow] = []
    var coinCount: Int = 0 {
        didSet {
            coinCountLabel.text = String(coinCount)
        }
    }
    var currentLevelHolder: String = "levelHolder1"
    var didTutJump: Bool = false
    var didTutShoot: Bool = false
    var firstTouchLocation = CGPointZero
    var fixedDelta: CFTimeInterval = 1.0/60.0
    var intervalMin: CGFloat = 0.5
    var intervalMax:CGFloat = 1.5
    var lastUpdateTime: CFTimeInterval = 0
    var playedGames: Int = 0
    var randomInterval: CGFloat!
    var score: CGFloat = 0 {
        didSet {
            let roundedScore = Int(round(score))
            scoreLabel.text = "\(roundedScore)m"
            ChallengeManager.sharedInstance.ranMeters(roundedScore)
        }
    }
    var timer: CFTimeInterval = 0
    
    var archer: Archer!
    var challengeCompletedBanner: SKSpriteNode!
    var challengeCompletedLabel: SKLabelNode!
    var clouds: SKEmitterNode!
    var coinCountLabel: SKLabelNode!
    var enemyScrollLayer: SKNode!
    var enemyScrollLayerFast: SKNode!
    var enemyScrollLayerSlow: SKNode!
    var firstChallengeLabel: SKLabelNode!
    var gameOverScreen: SKSpriteNode!
    var highScoreLabel: SKLabelNode!
    var invisibleGround: SKSpriteNode!
    var levelHolder1: SKSpriteNode!
    var levelHolder2: SKSpriteNode!
    var mountains1: SKSpriteNode!
    var mountains2: SKSpriteNode!
    var obstacleScrollLayer: SKNode!
    var playAgainButton: MSButtonNode!
    var startGroundLarge: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var scoreLabelGO: SKLabelNode!
    var secondChallengeLabel: SKLabelNode!
    var startMountains: SKSpriteNode!
    var startingScrollLayer: SKNode!
    var startTreesBack: SKSpriteNode!
    var startTreesFront: SKSpriteNode!
    var thirdChallengeLabel: SKLabelNode!
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
        enemyScrollLayer = self.childNodeWithName("enemyScrollLayer")
        enemyScrollLayerFast = self.childNodeWithName("enemyScrollLayerFast")
        enemyScrollLayerSlow = self.childNodeWithName("enemyScrollLayerSlow")
        firstChallengeLabel = self.childNodeWithName("//firstChallengeLabel") as! SKLabelNode
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        highScoreLabel = self.childNodeWithName("//highScoreLabel") as! SKLabelNode
        invisibleGround = self.childNodeWithName("//invisibleGround") as! SKSpriteNode
        levelHolder1 = self.childNodeWithName("levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNodeWithName("levelHolder2") as! SKSpriteNode
        mountains1 = self.childNodeWithName("mountains1") as! SKSpriteNode
        mountains2 = self.childNodeWithName("mountains2") as! SKSpriteNode
        obstacleScrollLayer = self.childNodeWithName("obstacleScrollLayer")
        playAgainButton = self.childNodeWithName("//playAgainButton") as! MSButtonNode
        startGroundLarge = self.childNodeWithName("//startGroundLarge") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabelGO = self.childNodeWithName("//scoreLabelGO") as! SKLabelNode
        secondChallengeLabel = self.childNodeWithName("//secondChallengeLabel") as! SKLabelNode
        startMountains = self.childNodeWithName("startMountains") as! SKSpriteNode
        startingScrollLayer = self.childNodeWithName("startingScrollLayer")
        startTreesBack = self.childNodeWithName("startTreesBack") as! SKSpriteNode
        startTreesFront = self.childNodeWithName("startTreesFront") as! SKSpriteNode
        thirdChallengeLabel = self.childNodeWithName("//thirdChallengeLabel") as! SKLabelNode
        treesBack1 = self.childNodeWithName("treesBack1") as! SKSpriteNode
        treesBack2 = self.childNodeWithName("treesBack2") as! SKSpriteNode
        treesFront1 = self.childNodeWithName("treesFront1") as! SKSpriteNode
        treesFront2 = self.childNodeWithName("treesFront2") as! SKSpriteNode
        water = self.childNodeWithName("//water") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        
        clouds.advanceSimulationTime(320)
        
        setupGroundPhysics()
        
        gameOverState = GameOverState(scene: self)
        playingState = PlayingState(scene: self)
        startingState = StartingState(scene: self)
        tutorialState = TutorialState(scene: self)
        
        gameState = GKStateMachine(states: [startingState, playingState, gameOverState, tutorialState])
        
        randomInterval = CGFloat.random(min: 0.3, max: 1.5)
        
        playAgainButton.selectedHandler = {
            if let scene = GameScene(fileNamed:"GameScene") {
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        playedGames = userDefaults.integerForKey("playedGames")
        
        firstChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["firstChallenge"]!.description()
        secondChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["secondChallenge"]!.description()
        thirdChallengeLabel.text = ChallengeManager.sharedInstance.activeChallenges["thirdChallenge"]!.description()
        
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
        
        //Player contact with floor
        if  (categoryA == PhysicsCategory.Floor && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Floor) {
            
            if archer.state == .Dead { return }
            
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
        
        //Player contacts obstacle
        if (categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Obstacle) {
            gameState.enterState(GameOverState)
        }
        
        if categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Arrow {
            if nodeA.isKindOfClass(Orc) {
                killOrc(nodeA, nodeArrow: nodeB)
            }
        }
        else if categoryA == PhysicsCategory.Arrow && categoryB == PhysicsCategory.Obstacle {
            if nodeB.isKindOfClass(Orc) {
                killOrc(nodeB, nodeArrow: nodeA)
            }
        }
        
        
        if categoryA == PhysicsCategory.Coin || categoryB == PhysicsCategory.Coin {
            if nodeA.isKindOfClass(Coin) {
                grabCoin(nodeA)
            }
            else if nodeB.isKindOfClass(Coin) {
                grabCoin(nodeB)
            }
        }
        
        if categoryA == PhysicsCategory.Target || categoryB == PhysicsCategory.Target {
            if nodeA.isKindOfClass(Target) {
                hitTargetWithSpikes(nodeA)
            }
            else if nodeB.isKindOfClass(Target) {
                hitTargetWithSpikes(nodeB)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if gameState.currentState is GameOverState || gameState.currentState is StartingState { return }
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        if location?.x < (frame.width / 2)/2 {
            // make the hero jump
            if archer.state == .Jumping { return }
            if gameState.currentState is TutorialState { didTutJump = true }
            archer.jump()
        }
        else {
            firstTouchLocation = touch!.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState.currentState is GameOverState || gameState.currentState is StartingState { return }
        
        let TouchDistanceThreshold: CGFloat = 4
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            if location.x > (frame.width / 2)/2 {
                let swipe = CGVector(dx: location.x - firstTouchLocation.x, dy: location.y - firstTouchLocation.y)
                let swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy)
                if swipeLength > TouchDistanceThreshold {
                    
                    let mag = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
                    
                    var arrowDx = -swipe.dx / mag
                    var arrowDy = -swipe.dy / mag
                    
                    //Block shooting backwards
                    if arrowDx < 0 {
                        arrowDx *= -1
                        arrowDy *= -1
                    }
                    let arrow = Arrow()
                    addChild(arrow)
                    arrows.append(arrow)
                    arrow.position = archer.position + CGPoint(x: 10, y: -10)
                    arrow.physicsBody?.applyImpulse(CGVector(dx: arrowDx * 4, dy: arrowDy * 4))
                    if gameState.currentState is TutorialState { didTutShoot = true }
                    ChallengeManager.sharedInstance.shotArrow()
                }
            }
        }
        
    }
   
    override func update(currentTime: NSTimeInterval) {
        
        /* Update states with deltaTime */
        var deltaTime = currentTime - lastUpdateTime
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
        /*let particles = SKEmitterNode(fileNamed: "CoinGrab")!
        // Look into position
        particles.position = obstacleScrollLayer.convertPoint(coin.position, fromNode: coin)
        particles.advanceSimulationTime(0.15)
        obstacleScrollLayer.addChild(particles)*/
        
        coin.removeFromParent()
        
        /*let removeParticlesAction = SKAction.runBlock({
            particles.removeFromParent()
        })
        
        let waitAction = SKAction.waitForDuration(0.15)
        
        let removeParticlesSequence = SKAction.sequence([waitAction, removeParticlesAction])
        
        obstacleScrollLayer.runAction(removeParticlesSequence)*/
        
        coinCount += 1
        
        ChallengeManager.sharedInstance.collectedCoin()
    }
    
    func killOrc(nodeOrc: SKNode, nodeArrow: SKNode) {
        let orc = nodeOrc as! Orc
        let arrow = nodeArrow as! Arrow
        
        //Remove arrow from parent
        let removeArrow = SKAction.runBlock({
            arrow.removeFromParent()
        })
        
        self.runAction(removeArrow)
        
        arrows.removeAtIndex(arrows.indexOf(arrow)!)
        
        orc.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
        
        orc.die()
        
        let removeAndAddOrc = SKAction.runBlock({
            orc.position = orc.parent!.convertPoint(orc.position, toNode: self.obstacleScrollLayer)
            orc.removeFromParent()
            self.obstacleScrollLayer.addChild(orc)
        })
        
        self.runAction(removeAndAddOrc)
        
        ChallengeManager.sharedInstance.killedOrc()
    }
    
    func hitTargetWithSpikes(node: SKNode) {
        let target = node as! Target
        
        for case let spike as Spike in target.children {
            let slideDown = SKAction.moveBy(CGVector(dx: 0, dy: -spike.size.height), duration: 0.25)
            let removeSpike = SKAction.runBlock({ spike.removeFromParent() })
            
            let slideAndRemove = SKAction.sequence([slideDown, removeSpike])
            
            spike.zPosition = -1
            spike.runAction(slideAndRemove)
        }
        
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
}
