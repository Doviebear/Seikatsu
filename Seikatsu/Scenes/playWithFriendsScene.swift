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
    
    
    var textFieldPlaceholder: SKNode!
    
    
    var youIndicator: SKSpriteNode!
    var player2Indicator: SKSpriteNode!
    var player3Indicator: SKSpriteNode!
    var playGameButton: SKSpriteNode!
    
    var player2Box: SKShapeNode!
    var player3Box: SKShapeNode!
    
    var gameCodeLabel: SKLabelNode!
    
    
    override func sceneDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldReturned(_:)), name: .returnText, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(gameNameTaken(_:)), name: .gameNameTaken, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFriendRoom(_:)), name: .updateFriendRoom, object: nil)
        
        createGameButton = self.childNode(withName: "createGameButton") as? SKSpriteNode
        
        joinGameButton = self.childNode(withName: "joinGameButton") as? SKSpriteNode
        
        instructionsLabel = self.childNode(withName: "instructionsLabel") as? SKLabelNode
        
        textFieldPlaceholder = self.childNode(withName: "textFieldPlaceholder")
        youIndicator = self.childNode(withName: "youIndicator") as? SKSpriteNode
        player2Indicator = self.childNode(withName: "player2Indicator") as? SKSpriteNode
        player3Indicator = self.childNode(withName: "player3Indicator") as? SKSpriteNode
        player2Box = self.childNode(withName: "player2Box") as? SKShapeNode
        player3Box = self.childNode(withName: "player3Box") as? SKShapeNode
        gameCodeLabel = self.childNode(withName: "gameCodeLabel") as? SKLabelNode
        playGameButton = self.childNode(withName: "playGameButton") as? SKSpriteNode
        
        
        
        currentStage = "root"
        
        backgroundColor = UIColor(rgb: 0x000000)
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
                    createGameButtonPressed()
                } else if node.name == "joinGameButton" {
                    joinGameButtonPressed()
                } else if node.name == "playGameButton" && currentStage == "inLobby" {
                    if let numInRoom = SocketIOHelper.helper.getNumInRoom() {
                        if numInRoom == 3 {
                            SocketIOHelper.helper.startFriendGame()
                        } else {
                            //Not enough players or somehow too many players, but I don't think thats possible
                            return
                        }
                    } else {
                        return
                    }
                }
            }
        }
    }
    
    func createGameButtonPressed() {
        createGameButton.isHidden = true
        joinGameButton.isHidden = true
        instructionsLabel.text = "Enter the name of your room"
        instructionsLabel.isHidden = false
        currentStage = "createGameButtonPressed"
        let posistionOfTextField = CGPoint(x: self.size.width/2  , y: self.size.height/2 )
        let convertedPosistion = view?.convert(posistionOfTextField, from: self)
        //let textFieldRect = CGRect(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y, width: 300, height: 100)
        let ArrayToSend = [convertedPosistion!, "creating"] as [Any]
        
        NotificationCenter.default.post(name: .showTextField, object: ArrayToSend )
        
        
    }
    
    func joinGameButtonPressed() {
       createGameButton.isHidden = true
        joinGameButton.isHidden = true
        instructionsLabel.text = "Enter the name of your room"
        instructionsLabel.isHidden = false
        currentStage = "joinGameButtonPressed"
        let posistionOfTextField = CGPoint(x: self.size.width/2  , y: self.size.height/2 )
        let convertedPosistion = view?.convert(posistionOfTextField, from: self)
        //let textFieldRect = CGRect(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y, width: 300, height: 100)
        let ArrayToSend = [convertedPosistion!, "joining"] as [Any]
        
        NotificationCenter.default.post(name: .showTextField, object: ArrayToSend )
        
    }
    
    @objc func textFieldReturned(_ notification: Notification) {
        guard let gameString = notification.object as? String else {
            return
        }
        print("gameString is: \(gameString)")
        
        if currentStage == "createGameButtonPressed" {
           changeToLobbyView(with: gameString)
            
        } else if currentStage == "joinGameButtonPressed" {
            changeToLobbyView(with: gameString)
            
            
        }
    }
    
    @objc func gameNameTaken(_ notification: Notification) {
        guard let gameString = notification.object as? String else {
            return
        }
        instructionsLabel.text = "'\(gameString)' is taken, please try another name"
        
    }
    
    @objc func updateFriendRoom(_ notification: Notification) {
        guard let numInRoom = notification.object as? Int else {
            return
        }
        if numInRoom == 2 {
            player2Box.isHidden = true
            player2Indicator.isHidden = false
        } else if numInRoom == 3 {
            player3Box.isHidden = true
            player3Indicator.isHidden = false
        }
        
        
    }
    
    func changeToLobbyView(with gameString: String? = nil) {
        instructionsLabel.isHidden = true
        NotificationCenter.default.post(name: .hideTextField, object: nil )
        
        player2Box.isHidden = false
        youIndicator.isHidden = false
        player3Box.isHidden = false
        
        gameCodeLabel.text = (gameCodeLabel.text ?? "Game Code: ") + (gameString ?? "")
        gameCodeLabel.isHidden = false
        playGameButton.isHidden = false
        currentStage = "inLobby"
        
        
    }
    
    
}


