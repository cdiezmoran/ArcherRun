//
//  LongRangeOrc.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/14/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class LongRangeOrc: Orc {
    
    var throwLeftAnimation: SKAction!
    var throwRightAnimation: SKAction!
    
    override init() {
        super.init()
        
        var textures: [SKTexture] = []
        
        //THROW-LEFT ANIMATION
        textures = getTextures("throw_left-", total: 8)
        throwLeftAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
        //THROW-RIGHT ANIMATION
        textures = getTextures("throw_right-", total: 8)
        throwRightAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        
        removeAllActions()
        
        //IDLE ANIMATION
        textures = getTextures("idleOrc-", total: 6)
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: false)
        let idleAction = SKAction.repeatActionForever(animation)
        runAction(idleAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
