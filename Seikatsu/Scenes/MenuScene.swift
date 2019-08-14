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
    
    var onlinePlayButton: SKShapeNode!
    var localPlayButton: SKShapeNode!
    
    override func sceneDidLoad() {
        onlinePlayButton = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        onlinePlayButton.fillColor = .blue
        onlinePlayButton.name = "OnlineButton"
        onlinePlayButton.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY + 150)
        addChild(onlinePlayButton)
        
        localPlayButton = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        localPlayButton.fillColor = .green
        localPlayButton.name = "LocalButton"
        localPlayButton.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY - 150)
        addChild(localPlayButton)
        

        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "OnlineButton" {
                    SocketIOHelper.helper.sendData()
                    return
                } else if node.name == "LocalButton" {
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene()
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: transition)
                    return
                }
            }
        }
    }
    
    
   
}
