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
        
       
        super.init(texture: textureToPut, color: .clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///Dimensions: radius: 50 pts, Gap between circles: 5 pts, center to center (from col to col): 60 pts
    func drawNode(on scene: SKScene, in hexagon: SKSpriteNode){
        self.TokenSize = Int(hexagon.size.height/8)
        self.name = "tokenSpace"
        self.zPosition = 8
        self.size = CGSize(width: TokenSize, height: TokenSize)
        let differenceBetweenCol = hexagon.size.width/8
        let inColDifference = hexagon.size.height/8
        let top = hexagon.position.y + hexagon.size.height/2
        //let bottom = hexagon.position.y - hexagon.size.height/2
        //let left = hexagon.position.x - hexagon.size.width/2
        let right = hexagon.position.x + hexagon.size.width/2
        if Location.col % 2 == 0 {
            let x = Int(right) - (Location.col * Int(differenceBetweenCol))
            let y = Int(top) - (Location.posistioningNumInCol * Int(inColDifference))
            self.position = CGPoint(x: x, y: y)
        } else {
            let x = Int(right) - (Location.col * Int(differenceBetweenCol))
            let y = Int(top) - (Location.posistioningNumInCol * Int(inColDifference)) - TokenSize/2
            self.position = CGPoint(x: x, y: y)
        }
        scene.addChild(self)
    }
    
    func setPosition(in hexagon: SKSpriteNode){
        let differenceBetweenCol = hexagon.size.width/8
        let inColDifference = hexagon.size.height/8
        let top = hexagon.position.y + hexagon.size.height/2
        //let bottom = hexagon.position.y - hexagon.size.height/2
        //let left = hexagon.position.x - hexagon.size.width/2
        let right = hexagon.position.x + hexagon.size.width/2
        if Location.col % 2 == 0 {
            let x = Int(right) - (Location.col * Int(differenceBetweenCol))
            let y = Int(top) - (Location.posistioningNumInCol * Int(inColDifference))
            self.position = CGPoint(x: x, y: y)
        } else {
            let x = Int(right) - (Location.col * Int(differenceBetweenCol))
            let y = Int(top) - (Location.posistioningNumInCol * Int(inColDifference)) - TokenSize/2
            self.position = CGPoint(x: x, y: y)
        }
    }
}

