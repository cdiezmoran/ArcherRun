//
//  ShopItem.swift
//  Archer Rush
//
//  Created by Carlos Diez on 8/22/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class ShopItem {
    
    var price: Int
    var texture: SKTexture
    var key: String
    var name: String
    var isBought: Bool
    
    init(key: String, isBought: Bool) {
        self.price = ShopItem.getPrice(key)
        self.texture = ShopItem.getTexture(key)
        self.name = ShopItem.getName(key)
        self.isBought = isBought
        self.key = key
    }
    
    static func getPrice(key: String) -> Int {
        var itemPrice: Int = 0
        
        switch key {
        case "ice", "fire":
            itemPrice = 5000
            break
        case "explosive":
            itemPrice = 7500
            break
        default:
            itemPrice = 0
            break
        }
        
        return itemPrice
    }
    
    static func getTexture(key: String) -> SKTexture {
        var texture: SKTexture!
        
        switch key {
        case "ice":
            texture = SKTexture(imageNamed: "shopIceArrow")
            break
        case "fire":
            texture = SKTexture(imageNamed: "shopFireArrow")
            break
        case "explosive":
            texture = SKTexture(imageNamed: "shopExplosiveArrow")
            break
        default:
            texture = SKTexture(imageNamed: "shopArrow")
        }
        
        return texture
    }
    
    static func getName(key: String) -> String {
        var name: String = ""
        
        switch key {
        case "ice":
            name = "Ice Arrow"
            break
        case "fire":
            name = "Fire Arrow"
            break
        case "explosive":
            name = "Explosive Arrow"
            break
        default:
            name = "Regular Arrow"
        }
        
        return name
    }
}
