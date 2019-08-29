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
    var playButton: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    
    var searchingForGameSprite: SKSpriteNode!
    
    
    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(joinedQueue(_:)), name: .joinedQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alreadyInQueue(_:)), name: .alreadyInQueue, object: nil)
        
        
        title = self.childNode(withName: "title") as? SKLabelNode
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            title.position = CGPoint(x: 1218, y: 795)
            playButton.position = CGPoint(x: 1218, y: 570)
            howToPlayButton.position = CGPoint(x: 958, y: 265)
            settingsButton.position = CGPoint(x: 1478, y: 265)
            searchingForGameSprite.position = CGPoint(x: 2780, y: 105)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            
            title.position = CGPoint(x: 1024, y: 1172)
            playButton.position = CGPoint(x: 1024, y: 835)
            howToPlayButton.position = CGPoint(x: 764, y: 535)
            settingsButton.position = CGPoint(x: 1284, y: 535)
            searchingForGameSprite.position = CGPoint(x: 2392, y: 165)
            
        }
        
    }
    
    func switchToPortrait() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            title.position = CGPoint(x: 562.5, y: 1750)
            playButton.position = CGPoint(x: 562.5, y: 1400)
            howToPlayButton.position = CGPoint(x: 302.5, y: 1085)
            settingsButton.position = CGPoint(x: 822.5, y: 1085)
            searchingForGameSprite.position = CGPoint(x: 1469, y: 180)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            title.position = CGPoint(x: 768, y: 1500)
            playButton.position = CGPoint(x: 768, y: 1060)
            howToPlayButton.position = CGPoint(x: 508, y: 765)
            settingsButton.position = CGPoint(x: 1028, y: 765)
            searchingForGameSprite.position = CGPoint(x: 1880, y: 160)
        }
    }
   
    
    
    @objc func joinedQueue(_ notification: Notification) {
        searchingForGameSprite.run(SKAction.moveBy(x: -(searchingForGameSprite.size.width), y: 0, duration: 0.3))
    }
    
    @objc func alreadyInQueue(_ notification: Notification) {
        
    }
}

