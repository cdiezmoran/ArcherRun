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
    static let None:    UInt32 = 0          // 0000
    static let Player:  UInt32 = 0b1        // 0001
    static let Obstacle:UInt32 = 0b10       // 0010
    static let Coin:    UInt32 = 0b100      // 0100
    static let Floor:   UInt32 = 0b1000     // 1000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GKStateMachine!
    var startingState: GKState!
    var playingState: GKState!
    var gameOverState: GKState!
    
    var lastUpdateTime: CFTimeInterval = 0
    
    var water: SKSpriteNode!
    var water2: SKSpriteNode!
    var clouds: SKEmitterNode!
    var startGroundLarge: SKSpriteNode!
    var startingScrollLayer: SKNode!
    var levelHolder1: SKSpriteNode!
    var levelHolder2: SKSpriteNode!
    var hero: Hero!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        water = self.childNodeWithName("//water") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        startGroundLarge = self.childNodeWithName("//startGroundLarge") as! SKSpriteNode
        startingScrollLayer = self.childNodeWithName("startingScrollLayer")
        levelHolder1 = self.childNodeWithName("levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNodeWithName("levelHolder2") as! SKSpriteNode
        
        hero = self.childNodeWithName("hero") as! Hero
        
        clouds.advanceSimulationTime(120)
        
        setupGroundPhysics()
        
        startingState = StartingState(scene: self)
        playingState = PlayingState(scene: self)
        gameOverState = GameOverState(scene: self)
        
        gameState = GKStateMachine(states: [startingState, playingState, gameOverState])
        
        gameState.enterState(StartingState)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print(contact.bodyA.node!.name)
        print(contact.bodyB.node!.name)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if !(gameState.currentState is PlayingState) { return }
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        if location?.x > frame.width / 2 {
            // make the hero jump
            hero.jump()
        }
    }
   
    override func update(currentTime: NSTimeInterval) {
        
        /* Update states with deltaTime */
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(deltaTime)
        
        /* Scroll water to make it look animated */
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func setupGroundPhysics() {
        startGroundLarge.physicsBody = SKPhysicsBody(rectangleOfSize: startGroundLarge.size)
        startGroundLarge.physicsBody?.affectedByGravity = false
        startGroundLarge.physicsBody?.dynamic = false
        startGroundLarge.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        startGroundLarge.physicsBody?.contactTestBitMask = PhysicsCategory.None
        startGroundLarge.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder1.physicsBody = SKPhysicsBody(rectangleOfSize: levelHolder1.size)
        levelHolder1.physicsBody?.affectedByGravity = false
        levelHolder1.physicsBody?.dynamic = false
        levelHolder1.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder1.physicsBody?.contactTestBitMask = PhysicsCategory.None
        levelHolder1.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder2.physicsBody = SKPhysicsBody(rectangleOfSize: levelHolder2.size)
        levelHolder2.physicsBody?.affectedByGravity = false
        levelHolder2.physicsBody?.dynamic = false
        levelHolder2.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder2.physicsBody?.contactTestBitMask = PhysicsCategory.None
        levelHolder2.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
}
