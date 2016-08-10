//
//  ShopExtension.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/5/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

extension GameScene {
    func selectedRowNode(node: SKSpriteNode) {
        // Check the node name to decide what to do here...
        if let name = node.name {
            if name == "close" {
                list.removeFromParent()
                return
            }
            
            let isEquipped = Arrow.isEquipped(name)
            let isBought: Bool = availableArrows[name]!
            let parent = node.parent!
            
            if !isBought {
                //get player's money count
                var totalCoinCount = userDefaults.integerForKey("totalCoins")
                //get cost of arrow
                let coinLabel = parent.childNodeWithName("coinLabel") as! SKLabelNode
                let coinCost = Int(coinLabel.text!)!
                //check if player can buy arrow
                if totalCoinCount > coinCost {
                    //remove cost of arrow from player money
                    totalCoinCount -= coinCost
                    //save totalCoinCount
                    userDefaults.setValue(totalCoinCount, forKey: "totalCoins")
                    //update coin count label
                    totalCoinCountLabel.text = String(totalCoinCount)
                    //update availableArrows dict
                    availableArrows[name] = true
                    userDefaults.setObject(availableArrows, forKey: "availableArrows")
                    userDefaults.synchronize()
                    //get node elements
                    let coinSprite = parent.childNodeWithName("coinSprite") as! SKSpriteNode
                    let buyLabel = parent.childNodeWithName("buyLabel") as! SKLabelNode
                    //modify node elements
                    coinLabel.removeFromParent()
                    coinSprite.removeFromParent()
                    buyLabel.text = "EQUIP"
                }
                else {
                    //fade or change color animation in buy label
                }
            }
            else {
                if !isEquipped {
                    Arrow.setEquippedTypeFromRawValue(name)
                }
                list.removeFromParent()
                return
            }
        }
    }
    
    func setupList() {
        list.delegate = self
        // Add the list to this scene
        addChild(list)
        // Position the list. THe reference point is in the center.
        list.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        for (key, value) in availableArrows {
            var costOfArrow: Int = 0
            
            if key == "fire" || key == "ice" {
                costOfArrow = 5000
            }
            else if key == "explosive"{
                costOfArrow = 7500
            }
            
            if value {
                let isEquipped = Arrow.isEquipped(key)
                createArrowRow(key, cost: 0, isBought: value, isEquipped: isEquipped)
            }
            else {
                createArrowRow(key, cost: costOfArrow, isBought: false, isEquipped: false)
            }
        }
        
        let row = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: list.size.width, height: 60))
        row.name = "close"
        
        let rowOverlay = SKSpriteNode(color: UIColor.clearColor(), size: row.size)
        rowOverlay.name = "close"
        rowOverlay.zPosition = 151
        row.addChild(rowOverlay)
        
        let closeLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        closeLabel.text = "CLOSE"
        closeLabel.fontColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        row.addChild(closeLabel)
        closeLabel.position = CGPoint(x: 0, y: 0)
        
        list.addNode(row)
    }
    
    func createArrowRow(name: String, cost: Int, isBought: Bool, isEquipped: Bool) {
        let rowColor = UIColor.flatCoffeeColor()
        let row = SKSpriteNode(color: rowColor, size: CGSize(width: list.size.width, height: 60))
        row.name = name
        
        let rowOverlay = SKSpriteNode(color: UIColor.clearColor(), size: row.size)
        rowOverlay.name = name
        rowOverlay.zPosition = 151
        row.addChild(rowOverlay)
        
        var arrowTexture: SKTexture!
        var titleText: String!
        
        if name == "regular" {
            arrowTexture = SKTexture(imageNamed: "arrow")
            titleText = "Regular Arrow"
        }
        else if name == "ice" {
            arrowTexture = SKTexture(imageNamed: "arrowIce")
            titleText = "Ice Arrow"
        }
        else if name == "fire" {
            arrowTexture = SKTexture(imageNamed: "arrowFire")
            titleText = "Fire Arrow"
        }
        else if name == "explosive" {
            arrowTexture = SKTexture(imageNamed: "arrowExplosive")
            titleText = "Explosive Arrow"
        }
        
        let arrowSprite = SKSpriteNode(texture: arrowTexture, color: UIColor.clearColor(), size: CGSize(width: 62, height: 10))
        row.addChild(arrowSprite)
        arrowSprite.position = CGPoint(x: -290, y: -4)
        
        let titleLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        titleLabel.text = titleText
        titleLabel.fontSize = 32
        titleLabel.horizontalAlignmentMode = .Left
        row.addChild(titleLabel)
        titleLabel.position.x = arrowSprite.position.x + 50
        titleLabel.position.y = -2
        
        if !isBought {
            let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clearColor(), size: CGSize(width: 21, height: 21))
            coinSprite.name = "coinSprite"
            row.addChild(coinSprite)
            coinSprite.position = CGPoint(x: -230, y: -18.5)
            
            let coinLabel = SKLabelNode(fontNamed: "Courier New")
            coinLabel.name = "coinLabel"
            coinLabel.text = String(cost)
            coinLabel.fontSize = 24
            coinLabel.horizontalAlignmentMode = .Left
            row.addChild(coinLabel)
            coinLabel.position = CGPoint(x: -220, y: -27)
        }
        
        let buyLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        buyLabel.name = "buyLabel"
        buyLabel.fontSize = 24
        row.addChild(buyLabel)
        buyLabel.position = CGPoint(x: 196, y: -5)
        
        if !isBought {
            buyLabel.text = "TAP TO BUY"
        }
        else {
            if isEquipped {
                buyLabel.text = "EQUIPPED"
            }
            else {
                buyLabel.text = "EQUIP"
            }
        }
        
        list.addNode(row)
    }
}
