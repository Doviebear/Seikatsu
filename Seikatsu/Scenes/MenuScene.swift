//
//  MenuScene.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/24/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit


class MenuScene: SKScene {
    
    var buttonNode: SKShapeNode!
    override func sceneDidLoad() {
        buttonNode = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        buttonNode.fillColor = .blue
        buttonNode.name = "Button"
        buttonNode.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY)
        addChild(buttonNode)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "Button" {
                    SocketIOHelper.helper.sendData()
                    return
                }
            }
        }
    }
    
    
   
}
