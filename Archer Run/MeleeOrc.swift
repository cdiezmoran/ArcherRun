//
//  MeleeOrc.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/14/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class MeleeOrc: Orc {
    
    override init() {
        super.init()
        
        //RUN ANIMATION
        var textures = [SKTexture]()
        textures = getTextures("walkOrc-", total: 14)
        
        let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        
        let runAnimation = SKAction.repeatActionForever(animate)
        
        runAction(runAnimation)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
