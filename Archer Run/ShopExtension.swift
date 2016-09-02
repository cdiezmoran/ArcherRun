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
        
        let alphaBlack = UIColor.blackColor().colorWithAlphaComponent(0.65)
        let bg = SKSpriteNode(color: alphaBlack, size: frame.size)
        window.addChild(bg)
        bg.zPosition = -5
        
        let closeButton = CloseButton()
        window.addChild(closeButton)
        closeButton.position = CGPoint(x: 265, y: 180)
        
        let totalLabel = SKLabelNode(fontNamed: "Menlo Regular")
        totalLabel.fontSize = 28
        totalLabel.text = "Total"
        window.addChild(totalLabel)
        totalLabel.position = CGPoint(x: -10, y: 160)
        
        let totalCoinsLabel = SKLabelNode(fontNamed: "Courier New Bold")
        totalCoinsLabel.fontSize = 32
        window.addChild(totalCoinsLabel)
        totalCoinsLabel.position = CGPoint(x: 0, y: 127.5)
        
        totalCoinsLabel.text = String(userDefaults.integerForKey("totalCoins"))
        
        let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clearColor(), size: CGSize(width: 30, height: 30))
        window.addChild(coinSprite)
        coinSprite.position = CGPoint(x: 44, y: 172)
        
        let arrowsTexture = SKTexture(imageNamed: "arrowsButton")
        let charactersTexture = SKTexture(imageNamed: "charactersButton")
        let miscTexture = SKTexture(imageNamed: "miscButton")
        
        let arrowsButton = MSButtonNode(texture: arrowsTexture, color: UIColor.clearColor(), size: arrowsTexture.size())
        window.addChild(arrowsButton)
        arrowsButton.position = CGPoint(x: 0, y: 70)
        
        arrowsButton.selectedHandler = {
            //Create arrows shop window
            self.createItemsWindowForCategory("arrows", menuWindowCoinLabel: totalCoinsLabel)
        }
        
        let charactersButton = MSButtonNode(texture: charactersTexture, color: UIColor.clearColor(), size: charactersTexture.size())
        window.addChild(charactersButton)
        charactersButton.position = CGPoint(x: 0, y: -35)
        
        let miscButton = MSButtonNode(texture: miscTexture, color: UIColor.clearColor(), size: miscTexture.size())
        window.addChild(miscButton)
        miscButton.position = CGPoint(x: 0, y: -140)
    }
    
    func createItemsWindowForCategory(category: String, menuWindowCoinLabel: SKLabelNode) {
        var itemData = [String: Bool]()
        var defaultsKey: String!
        var itemKeys = [String]()
        var spriteSize: CGSize!
        var totalCoinCount = userDefaults.integerForKey("totalCoins")
        
        if category == "arrows" {
            //get arrows data
            itemData = availableArrows
            defaultsKey = "availableArrows"
            //set size of item sprites
            spriteSize = CGSize(width: 306, height: 45)
        }
        else if category == "characters" {
            //get characters data
            defaultsKey = "availableCharacters"
            //set size of item sprites
            spriteSize = CGSize(width: 0, height: 0)
        }
        else if category == "misc" {
            //get misc data
            defaultsKey = "availableMisc"
            //set size of item sprites
            spriteSize = CGSize(width: 0, height: 0)
        }
        
        var priceDict = [String: Int]()
        for (key, _) in itemData {
            priceDict[key] = ShopItem.getPrice(key)
        }
        
        itemKeys = priceDict.keysSortedByValue(<)
        
        var item = ShopItem(key: itemKeys[shopIndex], isBought: itemData[itemKeys[shopIndex]]!)
        
        let window = SKSpriteNode(color: UIColor.flatCoffeeColor(), size: CGSize(width: 550, height: 380))
        gameOverScreen.addChild(window)
        window.zPosition = 55
        
        let closeButton = CloseButton()
        window.addChild(closeButton)
        closeButton.position = CGPoint(x: 265, y: 180)
        
        let itemHolder = SKSpriteNode(texture: SKTexture(imageNamed: "item-holder"), color: UIColor.clearColor(), size: CGSize(width: 414, height: 175))
        window.addChild(itemHolder)
        itemHolder.position = CGPoint(x: 0, y: 70)
        
        let itemSprite = SKSpriteNode(texture: item.texture, color: UIColor.clearColor(), size: spriteSize)
        itemHolder.addChild(itemSprite)
        itemSprite.position = CGPoint(x: 0, y: 20)
        itemSprite.zPosition = 5
        
        let priceLabel = SKLabelNode(fontNamed: "Courier New Bold")
        priceLabel.horizontalAlignmentMode = .Left
        priceLabel.fontSize = 28
        priceLabel.fontColor = UIColor.flatYellowColor()
        itemHolder.addChild(priceLabel)
        priceLabel.position = CGPoint(x: -155, y: -70)
        priceLabel.zPosition = 5
        
        let itemNameLabel = SKLabelNode(fontNamed: "Menlo Regular")
        itemNameLabel.fontSize = 36
        itemNameLabel.text = item.name
        window.addChild(itemNameLabel)
        itemNameLabel.position = CGPoint(x: 0, y: -65)
        
        let availableCoinsLabel = SKLabelNode(fontNamed: "Courier New Bold")
        availableCoinsLabel.horizontalAlignmentMode = .Left
        availableCoinsLabel.fontSize = 32
        availableCoinsLabel.text = String(totalCoinCount)
        window.addChild(availableCoinsLabel)
        availableCoinsLabel.position = CGPoint(x: -242, y: 161)
        
        let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "coinGold"), color: UIColor.clearColor(), size: CGSize(width: 30, height: 30))
        window.addChild(coinSprite)
        coinSprite.position = CGPoint(x: -250, y: 172.5)
        
        let prevButton = MSButtonNode(texture: SKTexture(imageNamed: "prevButton"), color: UIColor.clearColor(), size: CGSize(width: 103, height: 103))
        window.addChild(prevButton)
        prevButton.position = CGPoint(x: -140, y: -140)
        
        let nextButton = MSButtonNode(texture: SKTexture(imageNamed: "nextButton"), color: UIColor.clearColor(), size: CGSize(width: 103, height: 103))
        window.addChild(nextButton)
        nextButton.position = CGPoint(x: 140, y: -140)
        
        let manageButton = MSButtonNode(texture: SKTexture(imageNamed: "buyButton"), color: UIColor.clearColor(), size: CGSize(width: 207, height: 52))
        window.addChild(manageButton)
        manageButton.position = CGPoint(x: 0, y: -140)
        
        let selectHandler: () -> Void = {
            if category == "arrows" {
                Arrow.setEquippedTypeFromRawValue(item.key)
                manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
            }
            manageButton.state = .Disabled
        }
        
        let buyHandler: () -> Void = {
            if totalCoinCount > item.price {
                totalCoinCount -= item.price
                
                itemData[item.key] = true
                item.isBought = true
                
                self.userDefaults.setInteger(totalCoinCount, forKey: "totalCoins")
                self.userDefaults.setObject(itemData, forKey: defaultsKey)
                self.userDefaults.synchronize()
                
                let totalCoinString = String(totalCoinCount)
                availableCoinsLabel.text = totalCoinString
                self.totalCoinCountLabel.text = totalCoinString
                menuWindowCoinLabel.text = totalCoinString
                
                priceLabel.text = ""
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                
                manageButton.selectedHandler = selectHandler
            }
        }
        
        if item.isBought {
            priceLabel.text = ""
            if Arrow.isEquipped(item.key) {
                manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
                manageButton.state = .Disabled
            }
            else {
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                manageButton.selectedHandler = selectHandler
            }
        }
        else {
            priceLabel.text = String(item.price)
            manageButton.texture = SKTexture(imageNamed: "buyButton")
            manageButton.selectedHandler = buyHandler
        }
        
        nextButton.selectedHandler = {
            item = self.updateStoreItem(true, itemKeys: itemKeys, itemData: itemData, itemNameLabel: itemNameLabel, itemSprite: itemSprite, priceLabel: priceLabel, manageButton: manageButton, selectHandler: selectHandler, buyHandler: buyHandler)
        }
        prevButton.selectedHandler = {
            item = self.updateStoreItem(false, itemKeys: itemKeys, itemData: itemData, itemNameLabel: itemNameLabel, itemSprite: itemSprite, priceLabel: priceLabel, manageButton: manageButton, selectHandler: selectHandler, buyHandler: buyHandler)
        }
    }
    
    func updateStoreItem(next: Bool, itemKeys: [String], itemData: [String: Bool], itemNameLabel: SKLabelNode, itemSprite: SKSpriteNode, priceLabel: SKLabelNode, manageButton: MSButtonNode, selectHandler: () -> Void, buyHandler: () -> Void) -> ShopItem {
        if next {
            self.shopIndex += 1
            if self.shopIndex >= itemKeys.count {
                self.shopIndex = 0
            }
        }
        else {
            self.shopIndex -= 1
            if self.shopIndex < 0 {
                self.shopIndex = itemKeys.count - 1
            }
        }
        
        let item = ShopItem(key: itemKeys[self.shopIndex], isBought: itemData[itemKeys[self.shopIndex]]!)
        
        itemNameLabel.text = item.name
        itemSprite.texture = item.texture
        
        if item.isBought {
            priceLabel.text = ""
            if Arrow.isEquipped(item.key) {
                manageButton.texture = SKTexture(imageNamed: "equippedPlaceholder")
                manageButton.state = .Disabled
            }
            else {
                manageButton.texture = SKTexture(imageNamed: "selectButton")
                manageButton.selectedHandler = selectHandler
                manageButton.state = .Active
            }
        }
        else {
            priceLabel.text = String(item.price)
            manageButton.texture = SKTexture(imageNamed: "buyButton")
            manageButton.selectedHandler = buyHandler
            manageButton.state = .Active
        }
        
        return item
    }
}
