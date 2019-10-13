//
//  playWithFriendsScene.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 10/8/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit

class playWithFriendsScene: SKScene {
    
    var createGameButton: SKSpriteNode!
    var joinGameButton: SKSpriteNode!
    
    var instructionsLabel: SKLabelNode!
    
    var currentStage: String!
    
    var inputTextField: UITextField!
    
    var textFieldPlaceholder: SKNode!
    
    
    override func sceneDidLoad() {
        
        createGameButton = self.childNode(withName: "createGameButton") as? SKSpriteNode
        
        joinGameButton = self.childNode(withName: "joinGameButton") as? SKSpriteNode
        
        instructionsLabel = self.childNode(withName: "instructionsLabel") as? SKLabelNode
        
        textFieldPlaceholder = self.childNode(withName: "textFieldPlaceholder")
        
        currentStage = "root"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "createGameButton" {
                    //Change sprite to touched version
                } else if node.name == "joinGameButton" {
                    //chnage sprite to touched version
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "createGameButton" {
                    
                } else if node.name == "joinGameButton" {
                    
                }
            }
        }
    }
    
    func createGameButtonPressed() {
        createGameButton.isHidden = true
        joinGameButton.isHidden = true
        instructionsLabel.text = "Enter the name of your room"
        currentStage = "createGameButtonPressed"
        let textFieldRect = CGRect(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y, width: 300, height: 100)
        let textField = UITextField(frame: textFieldRect)
        inputTextField = textField
        
        
    }
    
    
   
    
}
