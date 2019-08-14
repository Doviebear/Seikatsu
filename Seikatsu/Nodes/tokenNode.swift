//
//  tokenNode.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit

/// Colors
// Flower yellow: 0xffff00
// flower blue: 0x003399
// flower pink: 0xff66ff
// flower purple : 0x4d004d

// bird yellow : 0xff9966
//bird green: 0x009933
//bird blue: 0x0066cc
// bird red: 0xcc0000

// Koi Pond: 0x6600ff

class tokenNode: SKNode {
    var sprite: SKSpriteNode?
    var flowers = ["Orange","Purple","Blue","Yellow"]
    var birds = ["Pink","Grey","Green","Red"]
    /*
    var flowerColors = [UIColor(rgb: 0xffff00), UIColor(rgb: 0x003399), UIColor(rgb: 0xff66ff), UIColor(rgb: 0x4d004d)]
    var birdColors = [UIColor(rgb: 0xff9966), UIColor(rgb: 0x009933), UIColor(rgb: 0x0066cc), UIColor(rgb: 0xcc0000) ]
     */
    var isKoiPond: Bool
    var tokenData: Token
    var TokenSize: Int!
    
    
    init(token: Token) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            TokenSize = 100
        } else {
            TokenSize = 85
        }
        
        if token.flowerType == "pond" {
            self.isKoiPond = true
            self.tokenData = token
            
            
            /*
            let pond = SKShapeNode(circleOfRadius: 50)
            pond.position = CGPoint(x: 0, y: 0)
            pond.lineWidth = 0
            pond.fillColor = UIColor(rgb: 0x6600ff)
            pond.zPosition = 50
            self.pond = pond
            */
            
            sprite = SKSpriteNode(imageNamed: "SeikatsuToken_KoiPond")
            sprite?.size = CGSize(width: TokenSize, height: TokenSize)
            sprite?.position = CGPoint(x: 0, y: 0)
            
            
            
            super.init()
            return
        }
        
        let finalSpriteString = "SeikatsuToken_" + token.birdType + token.flowerType
        sprite = SKSpriteNode(imageNamed: finalSpriteString)
        
        sprite?.size = CGSize(width: TokenSize, height: TokenSize)
        sprite?.position = CGPoint(x: 0, y: 0)
        self.isKoiPond = false
        self.tokenData = token
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeTokenNode(in position: CGPoint, on scene: SKScene) {
        self.name = "tokenNode"
        self.position = position
        self.zPosition = 20
        addChild(sprite!)
        scene.addChild(self)
        
    }
    
    func isAdjacent(tokenNode2: tokenNode) -> Bool {
        let col = self.tokenData.Location!.col
        let posistioningNumInCol = self.tokenData.Location!.posistioningNumInCol
        let col2 = tokenNode2.tokenData.Location!.col
        let posistioningNumInCol2 = tokenNode2.tokenData.Location!.posistioningNumInCol
        
        
        if col == col2 && posistioningNumInCol + 1 == posistioningNumInCol2 {
            return true
        } else if col == col2 && posistioningNumInCol - 1 == posistioningNumInCol2 {
            return true
        } else if col - 1 == col2 && posistioningNumInCol == posistioningNumInCol2 {
            return true
        } else if col + 1 == col2 && posistioningNumInCol == posistioningNumInCol2 {
            return true
        } else if col - 1 == col2 && posistioningNumInCol - 1 == posistioningNumInCol2 && col % 2 == 0 {
            return true
        } else if col + 1 == col2 && posistioningNumInCol - 1 == posistioningNumInCol2 && col % 2 == 0 {
            return true
        } else if col - 1 == col2 && posistioningNumInCol + 1 == posistioningNumInCol2 && col % 2 == 1 {
            return true
        } else if col + 1 == col2 && posistioningNumInCol + 1 == posistioningNumInCol2 && col % 2 == 1 {
          return true
        } else {
            return false
        }
    }
    
    
}





extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
