//
//  MeleeOrc.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/14/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class MeleeOrc: Orc {
    
    var runAnimation: SKAction!
    
    override init() {
        super.init()
        
        //RUN ANIMATION
        var textures = [SKTexture]()
        textures = getTextures("walkOrc-", total: 14)
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        
        runAnimation = SKAction.repeatForever(animate)
        
        run(runAnimation)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hitArcher() {
        removeAllActions()
        
        let wait = SKAction.wait(forDuration: throwAnimation.duration)
        
        let sequence = SKAction.sequence([throwAnimation, wait, runAnimation])
        
        run(sequence)
    }
}
