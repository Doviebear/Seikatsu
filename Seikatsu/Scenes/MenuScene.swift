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
    var notConnectedToServerSprite: SKSpriteNode!
    
    var testingSprite: SKSpriteNode!
    
    var playMenu: SKSpriteNode!
    var touchBufferNode: SKSpriteNode!
    
    var difficultyMenu: SKSpriteNode!
    var easyButton: SKSpriteNode!
    var mediumButton: SKSpriteNode!
    var hardButton: SKSpriteNode!
    
    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(joinedQueue(_:)), name: .joinedQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alreadyInQueue(_:)), name: .alreadyInQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectedToServer(_:)), name: .connectedToServer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playAgain(_:)), name: .playAgain, object: nil)
        
        
        
        title = self.childNode(withName: "title") as? SKLabelNode
        playButton = self.childNode(withName: "playgameButton") as? SKSpriteNode
        howToPlayButton = self.childNode(withName: "howToPlayButton") as? SKSpriteNode
        settingsButton = self.childNode(withName: "settingsButton") as? SKSpriteNode
        searchingForGameSprite = self.childNode(withName: "searchingForGameSprite") as? SKSpriteNode
        notConnectedToServerSprite = self.childNode(withName: "notConnectedToServer") as? SKSpriteNode
        playMenu = self.childNode(withName: "playMenu") as? SKSpriteNode
        difficultyMenu = self.childNode(withName: "difficultyContainer") as? SKSpriteNode
        easyButton = self.childNode(withName: "easyButton") as? SKSpriteNode
        mediumButton = self.childNode(withName: "mediumButton") as? SKSpriteNode
        hardButton = self.childNode(withName: "hardButton") as? SKSpriteNode
        //testingSprite = self.childNode(withName: "testingSprite") as? SKSpriteNode
        //testingSprite.removeFromParent()

        //print("status is: \(SocketIOHelper.helper.socket.status)")
        if SocketIOHelper.helper.socket.status != .connected {
            notConnectedToServerSprite.run(SKAction.moveBy(x: -(notConnectedToServerSprite.size.width), y: 0, duration: 0.3))
        }
        
        touchBufferNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.5),size:self.size)
        touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        touchBufferNode.zPosition = 100
        touchBufferNode.isHidden = true
        addChild(touchBufferNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "playButton" {
//                    playButton.texture = SKTexture(imageNamed: "playgameButtonPressed")
                    return
                } else if node.name == "howToPlayButton" {
//                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButtonPressed")
                    return
                } else if node.name == "settingsButton" {
//                    settingsButton.texture = SKTexture(imageNamed: "settingsButtonPressed")
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
                if node.name == "touchBufferNode" {
                    resetScene()
                    return
                }
                
                
                if node.name == "playButton" && SocketIOHelper.helper.socket.status == .connected{
                    touchBufferNode.isHidden = false
                    createPlayButtonPopup()
                    
                    
                    //SocketIOHelper.helper.searchForMatch()
//                    playButton.texture = SKTexture(imageNamed: "playgameButton")
                    return
                } else if node.name == "howToPlayButton" {
                    //addChild(testingSprite)
                    //SocketIOHelper.helper.createGame(gameID: "Boo")
//                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButtonPressed")
                   return
                } else if node.name == "settingsButton" {
                    //SocketIOHelper.helper.startFriendGame()
//                    settingsButton.texture = SKTexture(imageNamed: "settingsButtonPressed")
                    return
                }
                
                if node.name == "playOnlineButton" {
                    SocketIOHelper.helper.searchForMatch()
                    resetScene()
                    return
                } else if node.name == "playWithFriendsButton" {
                   let transition = SKTransition.flipVertical(withDuration: 0.5)
                    if let fileName = getFriendsSceneFileName() {
                        if let scene = playWithFriendsScene(fileNamed: fileName) {
                            scene.scaleMode = .aspectFill
                            
                           
                            self.view?.presentScene(scene, transition: transition)
                        } else {
                            print("Couldn't create playWithFriendsScene")
                        }
                    } else {
                        print("Couldn't get File Name for playWithFriendsScene")
                    }
                    return
                } else if node.name == "playSoloButton" {
                    difficultyMenu.isHidden = false
                    playMenu.isHidden = true
                    return
                    
                } else if node.name == "easyButton" {
                    startSingleplayerGame(with: "easy")
                } else if node.name == "mediumButton" {
                    startSingleplayerGame(with: "medium")
                } else if node.name == "hardButton" {
                    startSingleplayerGame(with: "hard")
                }
                
            }
        }
    }
    
    func startSingleplayerGame(with difficulty: String) {
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        if let fileName = getFileName(baseSKSName: "singleplayer") {
            let gameModel = GameModel()
            if let scene = singleplayerGameScene(fileNamed: fileName, gameModel: gameModel, difficulty: difficulty ) {
                scene.scaleMode = .aspectFill
                
                
                self.view?.presentScene(scene, transition: transition)
            } else {
                print("Couldn't create playWithFriendsScene")
            }
        } else {
            print("Couldn't get File Name for playWithFriendsScene")
        }
    }
    func createPlayButtonPopup(){
        playMenu.isHidden = false
    }
    
   
    
    func resetScene(){
        touchBufferNode.isHidden = true
        playMenu.isHidden = true
    }
    
    @objc func playAgain(_ notification: Notification){
        SocketIOHelper.helper.searchForMatch()
    }
    
    func switchToLandscape() {
        /*
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.size = CGSize(width: 2436, height: 1125 )
            
            title.position = CGPoint(x: 1218, y: 795)
            playButton.position = CGPoint(x: 1218, y: 570)
            howToPlayButton.position = CGPoint(x: 958, y: 265)
            settingsButton.position = CGPoint(x: 1478, y: 265)
            searchingForGameSprite.position = CGPoint(x: 2780, y: 105)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            self.size = CGSize(width: 2048, height: 1536 )
            
            title.position = CGPoint(x: 1024, y: 1172)
            playButton.position = CGPoint(x: 1024, y: 835)
            howToPlayButton.position = CGPoint(x: 764, y: 535)
            settingsButton.position = CGPoint(x: 1284, y: 535)
            searchingForGameSprite.position = CGPoint(x: 2392, y: 165)
            
        }
        */
    }
    
    func switchToPortrait() {
        /*
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.size = CGSize(width: 1125, height: 2436 )
            
            title.position = CGPoint(x: 562.5, y: 1750)
            playButton.position = CGPoint(x: 562.5, y: 1400)
            howToPlayButton.position = CGPoint(x: 302.5, y: 1085)
            settingsButton.position = CGPoint(x: 822.5, y: 1085)
            searchingForGameSprite.position = CGPoint(x: 1469, y: 180)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
             self.size = CGSize(width: 1536, height: 2048 )
            
            title.position = CGPoint(x: 768, y: 1500)
            playButton.position = CGPoint(x: 768, y: 1060)
            howToPlayButton.position = CGPoint(x: 508, y: 765)
            settingsButton.position = CGPoint(x: 1028, y: 765)
            searchingForGameSprite.position = CGPoint(x: 1880, y: 160)
        }
         */
    }
   
    func getFriendsSceneFileName() -> String? {
//        let baseSKSName = "friendsScene"
        var fullSKSNameToLoad:String
        fullSKSNameToLoad = "friendsScenePhonePortrait"
        /*
        if ( UIDevice.current.userInterfaceIdiom == .pad) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadLand"){
                    // this if statement would NOT be true if the iPad file did not exist
                    fullSKSNameToLoad = baseSKSName + "PadLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadPortrait"){
                    // this if statement would NOT be true if the iPad file did not exist
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadPortrait"){
                    // this if statement would NOT be true if the iPad file did not exist
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                } else {
                    return nil
                }
            } else {
                fullSKSNameToLoad = baseSKSName + "PadPortrait"
            }
        } else if ( UIDevice.current.userInterfaceIdiom == .phone) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhoneLand"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhoneLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else  {
                fullSKSNameToLoad = baseSKSName + "PhonePortrait"
            }
            //worry about TV later
        } else {
            return nil
        }
        */
        return fullSKSNameToLoad
    }
    
    func getFileName(baseSKSName: String) -> String? {
        //We call this function with a baseSKSName passed in, and return either a
        //modified name or the same name if no other device specific SKS files are found.
        //For example, if baseSKSName = Level1 and Level1TV.sks exists in the project,
        //then the string returned is Level1TV
        var fullSKSNameToLoad:String
        if ( UIDevice.current.userInterfaceIdiom == .pad) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadLand"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadPortrait"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                   
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadPortrait"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                } else {
                    return nil
                }
            } else {
                fullSKSNameToLoad = baseSKSName + "PadPortrait"
                
            }
        } else if ( UIDevice.current.userInterfaceIdiom == .phone) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhoneLand"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhoneLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else {
                 fullSKSNameToLoad = baseSKSName + "PhonePortrait"
            }
            //worry about TV later
        } else {
            return nil
        }
        return fullSKSNameToLoad
    }
        
        
    
    @objc func joinedQueue(_ notification: Notification) {
        searchingForGameSprite.run(SKAction.moveBy(x: -(searchingForGameSprite.size.width), y: 0, duration: 0.3))
    }
    
    @objc func alreadyInQueue(_ notification: Notification) {
        
    }
    @objc func connectedToServer( _ notification: Notification) {
        notConnectedToServerSprite.run(SKAction.moveBy(x: notConnectedToServerSprite.size.width, y: 0, duration: 0.3))
    }
}

/*
extension SKScene {
    
}
*/
