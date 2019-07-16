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
    
    init(Location: Location, textureName: String){
        
        self.Location = Location
        let textureToPut = SKTexture(imageNamed: textureName)
        super.init(texture: textureToPut, color: .clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///Dimensions: radius: 50 pts, Gap between circles: 5 pts, center to center (from col to col): 60 pts
    func drawNode(on scene: SKScene){
        self.name = "tokenSpace"
        self.zPosition = 2
        if Location.col % 2 == 0 {
            let x = 1000 - self.Location.col * 110
            let y = Int(JKGame.rect.maxY) - 100 - Location.posistioningNumInCol * 110
            self.position = CGPoint(x: x, y: y)
        } else {
            let x = 1000 - self.Location.col * 110
            let y = Int(JKGame.rect.maxY) - 150 - Location.posistioningNumInCol * 110
            self.position = CGPoint(x: x, y: y)
        }
        scene.addChild(self)
    }
}
