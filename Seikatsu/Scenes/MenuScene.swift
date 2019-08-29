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
    
    
    var playButton: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    
    var searchingForGameSprite: SKSpriteNode!
    
    
    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(joinedQueue(_:)), name: .joinedQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alreadyInQueue(_:)), name: .alreadyInQueue, object: nil)
        
        
        
        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
        howToPlayButton = self.childNode(withName: "howToPlayButton") as? SKSpriteNode
        settingsButton = self.childNode(withName: "settingsButton") as? SKSpriteNode
        searchingForGameSprite = self.childNode(withName: "searchingForGameSprite") as? SKSpriteNode
        

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "playButton" {
                  
                    return
                } else if node.name == "howToPlayButton" {
                    return
                } else if node.name == "settingsButton" {
                    return
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "playButton" {
                    SocketIOHelper.helper.searchForMatch()
                    return
                } else if node.name == "howToPlayButton" {
                   return
                } else if node.name == "settingsButton" {
                    return
                }
            }
        }
    }
    
    
    
    func switchToLandscape() {
        
    }
    
    func switchToPortrait() {
        
    }
   
    
    
    @objc func joinedQueue(_ notification: Notification) {
        searchingForGameSprite.run(SKAction.moveBy(x: -688, y: 0, duration: 0.3))
    }
    
    @objc func alreadyInQueue(_ notification: Notification) {
        
    }
}

