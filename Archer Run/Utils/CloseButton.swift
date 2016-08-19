//
//  CloseButton.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/18/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class CloseButton: SKSpriteNode {
    
    let defaultTexture = SKTexture(imageNamed: "closeButton")
    
    init() {
        super.init(texture: defaultTexture, color: UIColor.clearColor(), size: CGSize(width: 40, height: 40))
        
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //remove window from parent to "close"
        self.parent!.removeFromParent()
    }
}
