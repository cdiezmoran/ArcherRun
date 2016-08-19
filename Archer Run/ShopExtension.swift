//
//  ShopExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/5/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func createShopMenuWindow() {
        let window = SKSpriteNode(color: UIColor.flatCoffeeColor(), size: CGSize(width: 550, height: 380))
        gameOverScreen.addChild(window)
        window.zPosition = 50
        
        let alphaBlack = UIColor.blackColor().colorWithAlphaComponent(0.75)
        let bg = SKSpriteNode(color: alphaBlack, size: frame.size)
        window.addChild(bg)
        bg.zPosition = -5
        
        let closeButton = CloseButton()
        window.addChild(closeButton)
        closeButton.position = CGPoint(x: 265, y: 180)
        
        let arrowsTexture = SKTexture(imageNamed: "arrowsButton")
        let charactersTexture = SKTexture(imageNamed: "charactersButton")
        let miscTexture = SKTexture(imageNamed: "miscButton")
        
        let arrowsButton = MSButtonNode(texture: arrowsTexture, color: UIColor.clearColor(), size: arrowsTexture.size())
        window.addChild(arrowsButton)
        arrowsButton.position = CGPoint(x: 0, y: 70)
        
        arrowsButton.selectedHandler = {
            //Create arrows shop window
        }
        
        let charactersButton = MSButtonNode(texture: charactersTexture, color: UIColor.clearColor(), size: charactersTexture.size())
        window.addChild(charactersButton)
        charactersButton.position = CGPoint(x: 0, y: -35)
        
        let miscButton = MSButtonNode(texture: miscTexture, color: UIColor.clearColor(), size: miscTexture.size())
        window.addChild(miscButton)
        miscButton.position = CGPoint(x: 0, y: -140)
    }
    
}
