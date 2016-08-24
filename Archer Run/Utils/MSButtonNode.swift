//
//  MSButtonNode.swift
//  Make School
//
//  Created by Martin Walsh on 20/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case Active, MSButtonNodeStateSelected, MSButtonNodeStateHidden, Disabled
}

class MSButtonNode: SKSpriteNode {
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    /* Button state management */
    var state: MSButtonNodeState = .Active {
        didSet {
            switch state {
            case .Active:
                /* Enable touch */
                self.userInteractionEnabled = true
                
                /* Visible */
                self.alpha = 1
                break
            case .MSButtonNodeStateSelected:
                /* Semi transparent */
                self.alpha = 0.7
                break
            case .MSButtonNodeStateHidden:
                /* Disable touch */
                self.userInteractionEnabled = false
                
                /* Hide */
                self.alpha = 0
                break
            case .Disabled:
                self.userInteractionEnabled = false
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.userInteractionEnabled = true
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.userInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        state = .MSButtonNodeStateSelected
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectedHandler()
        state = .Active
    }
    
}
