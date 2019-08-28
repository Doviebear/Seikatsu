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
    
    var title: SKLabelNode!
    var onlinePlayButton: SKShapeNode!
    var onlinePlayLabel: SKLabelNode!
    
    //var localPlayButton: SKShapeNode!
    
    
    var howToPlayButton: SKShapeNode!
    var howToPlayLabel: SKLabelNode!
    
    override func sceneDidLoad() {
        
        title = SKLabelNode(text: "Seikatsu")
        title.color = UIColor(rgb: 0xffffff)
        title.position = CGPoint(x: JKGame.rect.midX , y: JKGame.rect.maxY - 200)
        title.fontSize = 76
        title.fontName = "Courier"
        addChild(title)
        
        
        onlinePlayButton = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        onlinePlayButton.fillColor = UIColor(rgb: 0x00cc00 )
        onlinePlayButton.name = "OnlineButton"
        onlinePlayButton.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY + 150)
        addChild(onlinePlayButton)
        
        /*
        localPlayButton = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        localPlayButton.fillColor = .green
        localPlayButton.name = "LocalButton"
        localPlayButton.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY - 150)
        addChild(localPlayButton)
         */
        
        howToPlayButton = SKShapeNode(rectOf: CGSize(width: 300, height: 200))
        howToPlayButton.fillColor = UIColor(rgb: 0x3399ff)
        howToPlayButton.name = "howToPlayButton"
        howToPlayButton.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY - 400)
        addChild(howToPlayButton)
        

        
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
                    /*
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    if let gameScene = GameScene(fileNamed: "GameSceneOnlinePhonePortrait") {
                        gameScene.scaleMode = .aspectFill
                        //gameScene.size = JKGame.size
                        self.view?.presentScene(gameScene, transition: transition)
                        if let currentViewController = self.view?.findViewController() as? GameViewController {
                            currentViewController.currentScene = gameScene
                        }
                        
                        return
                    }
                     */
                } else if node.name == "howToPlayButton" {
                   
                }
            }
        }
    }
    
    
   
}

