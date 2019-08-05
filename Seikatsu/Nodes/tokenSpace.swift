//
//  tokenSpace.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit

class TokenSpace: SKSpriteNode {
    var Location: Location
    var TokenSize: Int!
    
    init(Location: Location, textureName: String){
        
        self.Location = Location
        let textureToPut = SKTexture(imageNamed: textureName)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            TokenSize = 100
        } else {
            TokenSize = 75
        }
        super.init(texture: textureToPut, color: .clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///Dimensions: radius: 50 pts, Gap between circles: 5 pts, center to center (from col to col): 60 pts
    func drawNode(on scene: SKScene){
        self.name = "tokenSpace"
        self.zPosition = 8
        let colDifference = TokenSize + (TokenSize/10)
        if Location.col % 2 == 0 {
            let x = Int(JKGame.rect.width/2) + (4 * colDifference) - self.Location.col * colDifference
            let y = Int(JKGame.rect.midY) + (4 * colDifference) - (Location.posistioningNumInCol * colDifference)
            self.position = CGPoint(x: x, y: y)
        } else {
            let x = Int(JKGame.rect.width/2) + (4 * colDifference) - self.Location.col * colDifference
            let y = Int(JKGame.rect.midY) + (4 * colDifference) - (Location.posistioningNumInCol * colDifference) - TokenSize/2
            self.position = CGPoint(x: x, y: y)
        }
        scene.addChild(self)
    }
}

