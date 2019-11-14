//
//  MenuScene.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/24/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit
import Sentry


class MenuScene: SKScene {
    
    var title: SKSpriteNode!
    var playButton: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    var background: SKSpriteNode!
    var screenArt: SKSpriteNode!
    
    var searchingForGameSprite: SKSpriteNode!
    var notConnectedToServerSprite: SKSpriteNode!
    var stopSearchingForGameSprite: SKSpriteNode!
    
    var testingSprite: SKSpriteNode!
    
    
    var touchBufferNode: SKSpriteNode!
    var searchingForMatch = false
    
    
    
    var playMenu: SKSpriteNode!
    var playWithFriendsButton: SKSpriteNode!
    var playOnlineButton: SKSpriteNode!
    var playSoloButton: SKSpriteNode!
    
    
    var difficultyMenu: SKSpriteNode!
    var easyButton: SKSpriteNode!
    var mediumButton: SKSpriteNode!
    var hardButton: SKSpriteNode!
    
    var createOrJoinMenu: SKSpriteNode!
    var createGameButton: SKSpriteNode!
    var joinGameButton: SKSpriteNode!
    
    var gameCodeMenu: SKSpriteNode!
    var playWithFriendsInfoLabel: SKLabelNode!
    var textFieldPlaceholder: SKNode!
    var gameCodeButton: SKSpriteNode!
    var tryAgainLabel: SKLabelNode!
    
    var gameLobbyContainer: SKSpriteNode!
    var player1Indicator: SKLabelNode!
    var player2Indicator: SKLabelNode!
    var player3Indicator: SKLabelNode!
    var lobbyIndicator: SKLabelNode!
    var startFriendGameButton: SKSpriteNode!
    var waitingForHostLabel: SKLabelNode!
    var gameCodeLabel: SKLabelNode!
    
    var isFriendGameCreate: Bool!
    var friendGameString: String!
    var loadingSprite: SKSpriteNode!
    
    var currentlyConnected = true
    var backgroundMusic: SKAudioNode!
    
    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(joinedQueue(_:)), name: .joinedQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alreadyInQueue(_:)), name: .alreadyInQueue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectedToServer(_:)), name: .connectedToServer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playAgain(_:)), name: .playAgain, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serverTimedOut(_:)), name: .serverTimeout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSoloGameAgain(_:)), name: .playSoloGameAgain, object: nil)
        
        
        
        title = self.childNode(withName: "title") as? SKSpriteNode
        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
        howToPlayButton = self.childNode(withName: "howToPlayButton") as? SKSpriteNode
        settingsButton = self.childNode(withName: "settingsButton") as? SKSpriteNode
        searchingForGameSprite = self.childNode(withName: "searchingForGameSprite") as? SKSpriteNode
        notConnectedToServerSprite = self.childNode(withName: "notConnectedToServer") as? SKSpriteNode
        background = self.childNode(withName: "background") as? SKSpriteNode
        screenArt = self.childNode(withName: "screenArt") as? SKSpriteNode
        
        playMenu = self.childNode(withName: "playMenu") as? SKSpriteNode
        playOnlineButton = playMenu.childNode(withName: "playOnlineButton") as? SKSpriteNode
        playSoloButton = playMenu.childNode(withName: "playSoloButton") as? SKSpriteNode
        playWithFriendsButton = playMenu.childNode(withName: "playWithFriendsButton") as? SKSpriteNode
        
        
        difficultyMenu = self.childNode(withName: "difficultyContainer") as? SKSpriteNode
        easyButton = difficultyMenu.childNode(withName: "easyButton") as? SKSpriteNode
        mediumButton = difficultyMenu.childNode(withName: "mediumButton") as? SKSpriteNode
        hardButton = difficultyMenu.childNode(withName: "hardButton") as? SKSpriteNode
        
         //testingSprite = self.childNode(withName: "testingSprite") as? SKSpriteNode
        //testingSprite.removeFromParent()
        gameCodeMenu = self.childNode(withName: "gameCodeContainer") as? SKSpriteNode
        createOrJoinMenu = self.childNode(withName: "playWithFriendsContainer") as? SKSpriteNode
        gameLobbyContainer = self.childNode(withName: "gameLobbyContainer") as? SKSpriteNode
        gameCodeLabel = gameLobbyContainer.childNode(withName: "gameCodeLabel") as? SKLabelNode
        tryAgainLabel = gameCodeMenu.childNode(withName: "tryAgainLabel") as? SKLabelNode

        //print("status is: \(SocketIOHelper.helper.socket.status)")
        if SocketIOHelper.helper.socket.status != .connected {
            notConnectedToServerSprite.run(SKAction.moveBy(x: -(notConnectedToServerSprite.size.width), y: 0, duration: 0.3))
            currentlyConnected = false
        }
        
        touchBufferNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.5),size:self.size)
        touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        touchBufferNode.zPosition = 100
        touchBufferNode.isHidden = true
        touchBufferNode.name = "touchBufferNode"
        addChild(touchBufferNode)
        
        // PlayWithFriends Stuff
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldReturned(_:)), name: .returnText, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(gameNameTaken(_:)), name: .gameNameTaken, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFriendRoom(_:)), name: .updateFriendRoom, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removedFromQueue(_:)), name: .removedFromQueue, object: nil)
        
        createGameButton = createOrJoinMenu.childNode(withName: "createGameButton") as? SKSpriteNode
        
        joinGameButton = createOrJoinMenu.childNode(withName: "joinGameButton") as? SKSpriteNode
        
        playWithFriendsInfoLabel = gameCodeMenu.childNode(withName: "playWithFriendsInfoLabel") as? SKLabelNode
        
        textFieldPlaceholder = self.childNode(withName: "textFieldPlaceholder")
        player1Indicator = gameLobbyContainer.childNode(withName: "youIndicator") as? SKLabelNode
        player2Indicator = gameLobbyContainer.childNode(withName: "player2Indicator") as? SKLabelNode
        player3Indicator = gameLobbyContainer.childNode(withName: "player3Indicator") as? SKLabelNode
        lobbyIndicator = gameLobbyContainer.childNode(withName: "lobbyIndicator") as? SKLabelNode
        
        
        gameCodeButton = gameCodeMenu.childNode(withName: "gameCodeButton") as? SKSpriteNode
        startFriendGameButton = gameLobbyContainer.childNode(withName: "startFriendGameButton") as? SKSpriteNode
        waitingForHostLabel = gameLobbyContainer.childNode(withName: "waitingForHostLabel") as? SKLabelNode
        loadingSprite = self.childNode(withName: "loadingSprite") as? SKSpriteNode
        
        stopSearchingForGameSprite = self.childNode(withName: "stopSearchingForGameSprite") as? SKSpriteNode
        
        /*
        let rotate = SKAction.rotate(byAngle: -(CGFloat((2.0 * Float.pi) / 12.0)), duration: 0)
        let wait = SKAction.wait(forDuration: 0.1)
       
        let sequence = SKAction.sequence([rotate, wait])
        let repeatAction = SKAction.repeatForever(sequence)
        loadingSprite.run(repeatAction, withKey: "spinningAnimation")
        */
        adjustGraphics()
        
        
        ///Adding Music
        
        
        if let musicURL = Bundle.main.url(forResource: "title1", withExtension: "wav") {
            let bg = SKAudioNode(url: musicURL)
            addChild(bg)
//            backgroundMusic = bg
            print("Found music")
        } else {
            print("Couldn't find music")
        }
        
        
    }
    /*
    override func didMove(to view: SKView) {
      
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if let node = nodesArray.first {
                if node.name == "playButton" {
                    let newTexture = SKTexture(imageNamed: "playGameButtonPressed")
                    playButton.texture = newTexture
                    return
                } else if node.name == "howToPlayButton" {
                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButtonPressed")
                    return
                } else if node.name == "settingsButton" {
                    settingsButton.texture = SKTexture(imageNamed: "settingsButtonPressed")
                    return
                } else if node.name == "gameCodeButton" {
                    if isFriendGameCreate {
                        gameCodeButton.texture = SKTexture(imageNamed: "createGameButtonPressed")
                    } else {
                        gameCodeButton.texture = SKTexture(imageNamed: "joinGameButtonPressed")
                    }
                    return
                    
                } else if node.name == "startFriendGameButton" {
                    startFriendGameButton.texture = SKTexture(imageNamed: "playGameButtonPressed")
                    return
                } else if node.name == "playWithFriendsButton" && !searchingForMatch{
                    playWithFriendsButton.texture = SKTexture(imageNamed: "playWithFriendsButtonPressed")
                    return
                } else if node.name == "playOnlineButton" {
                    playOnlineButton.texture = SKTexture(imageNamed: "playOnlineButtonPressed")
                    return
                } else if node.name == "playSoloButton" && !searchingForMatch {
                    playSoloButton.texture = SKTexture(imageNamed: "playSoloButtonPressed")
                    return
                } else if node.name == "createGameButton" {
                    createGameButton.texture = SKTexture(imageNamed: "createGameButtonPressed")
                    return
                } else if node.name == "joinGameButton" {
                    joinGameButton.texture = SKTexture(imageNamed: "joinGameButtonPressed")
                    return
                } else if node.name == "easyButton" {
                    easyButton.texture = SKTexture(imageNamed: "easyButtonPressed")
                    return
                } else if node.name == "mediumButton" {
                    mediumButton.texture = SKTexture(imageNamed: "mediumButtonPressed")
                    return
                } else if node.name == "hardButton" {
                    hardButton.texture = SKTexture(imageNamed: "hardButtonPressed")
                    return
                }
            }
        }
    }
   
        
        
        
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if let node = nodesArray.first {
                if node.name == "touchBufferNode" {
                    resetScene()
                    return
                }
                
                
                if node.name == "playButton"  {
                    playButton.texture = SKTexture(imageNamed: "playGameButton")
                    touchBufferNode.isHidden = false
                    createPlayButtonPopup()
                    return
                } else if node.name == "howToPlayButton" {
                 
                   
                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButton")
                   return
                } else if node.name == "settingsButton" {
                    settingsButton.texture = SKTexture(imageNamed: "settingsButton")
                    return
                }
                
                if node.name == "playOnlineButton" && SocketIOHelper.helper.socket.status == .connected {
                    playOnlineButton.texture = SKTexture(imageNamed: "playOnlineButton")
                    SocketIOHelper.helper.searchForMatch()
                    resetScene()
                    return
                } else if node.name == "playWithFriendsButton" && !searchingForMatch {
                    playWithFriendsButton.texture = SKTexture(imageNamed: "playWithFriendsButton")
                    playMenu.isHidden = true
                    createOrJoinMenu.isHidden = false
                } else if node.name == "playSoloButton" && !searchingForMatch {
                    playSoloButton.texture = SKTexture(imageNamed: "playSoloButton")
                    difficultyMenu.isHidden = false
                    playMenu.isHidden = true
                    return
                    
                } else if node.name == "easyButton" {
                     easyButton.texture = SKTexture(imageNamed: "easyButton")
                    startSingleplayerGame(with: "easy")
                    return
                } else if node.name == "mediumButton" {
                     mediumButton.texture = SKTexture(imageNamed: "mediumButton")
                    startSingleplayerGame(with: "medium")
                    return
                } else if node.name == "hardButton" {
                    hardButton.texture = SKTexture(imageNamed: "hardButton")
                    startSingleplayerGame(with: "hard")
                    return
                } else if node.name == "createGameButton" {
                    createGameButton.texture = SKTexture(imageNamed: "createGameButton")
                    createOrJoinMenu.isHidden = true
                    gameCodeMenu.isHidden = false
                    gameCodeButton.texture = SKTexture(imageNamed: "createGameButton")
                    isFriendGameCreate = true
                    playWithFriendsInfoLabel.text = "Create Game Code Below"
                    
                    let posistionOfTextField = CGPoint(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y)
                  
                    let convertedPosistion = view?.convert(posistionOfTextField, from: self)
                    //let textFieldRect = CGRect(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y, width: 300, height: 100)
                    let ArrayToSend = [convertedPosistion!, "creating"] as [Any]
                    
                    NotificationCenter.default.post(name: .showTextField, object: ArrayToSend )
                    
                    return
                } else if node.name == "joinGameButton" {
                    joinGameButton.texture = SKTexture(imageNamed: "joinGameButton")
                    isFriendGameCreate = false
                    createOrJoinMenu.isHidden = true
                    gameCodeMenu.isHidden = false
                    gameCodeButton.texture = SKTexture(imageNamed: "joinGameButton")
                    playWithFriendsInfoLabel.text = "Enter Game Code Below"
                    
                    let posistionOfTextField = CGPoint(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y)
                    let convertedPosistion = view?.convert(posistionOfTextField, from: self)
                    //let textFieldRect = CGRect(x: textFieldPlaceholder.position.x, y: textFieldPlaceholder.position.y, width: 300, height: 100)
                    let ArrayToSend = [convertedPosistion!, "joining"] as [Any]
                    
                    NotificationCenter.default.post(name: .showTextField, object: ArrayToSend )
                    
                    return
                } else if node.name == "gameCodeButton" {
                    if isFriendGameCreate {
                        gameCodeButton.texture = SKTexture(imageNamed: "createGameButton")
                    } else {
                        gameCodeButton.texture = SKTexture(imageNamed: "joinGameButton")
                    }
                    
                    NotificationCenter.default.post(name: .checkGameCode , object: nil)
                    //TODO Loading Animation
                    return
                } else if node.name == "startFriendGameButton" {
                    startFriendGameButton.texture = SKTexture(imageNamed: "playGameButton" )
                    SocketIOHelper.helper.startFriendGame(nameOfGame: friendGameString)
                    return
                    /*
                    if let numInRoom = SocketIOHelper.helper.getNumInRoom() {
                        print("numInRoom is \(numInRoom)")
                        if numInRoom == 3 {
                            SocketIOHelper.helper.startFriendGame(nameOfGame: friendGameString)
                        } else {
                            //Not enough players or somehow too many players, but I don't think thats possible
                            print("Something went wrong, not enough players or too many players in room")
                            return
                        }
                        return
                    }
                     */
                } else if node.name == "stopSearchingForGameSprite" {
                    stopSearchingForGame()
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
    
    func startLoadingAnimation(at posistion: CGPoint){
        loadingSprite.isHidden = false
        loadingSprite.position = posistion
        let rotate = SKAction.rotate(byAngle: -(CGFloat((2.0 * Float.pi) / 12.0)), duration: 0)
        let wait = SKAction.wait(forDuration: 0.1)
        
        let sequence = SKAction.sequence([rotate, wait])
        let repeatAction = SKAction.repeatForever(sequence)
        loadingSprite.run(repeatAction, withKey: "spinningAnimation")
    }
    
    func stopLoadingAnimation(){
        loadingSprite.isHidden = true
        loadingSprite.removeAction(forKey: "spinningAnimation")
    }
    
   
    
    func resetScene(){
        touchBufferNode.isHidden = true
        playMenu.isHidden = true
        gameCodeMenu.isHidden = true
        difficultyMenu.isHidden = true
        createOrJoinMenu.isHidden = true
        gameLobbyContainer.isHidden = true
        NotificationCenter.default.post(name: .hideTextField, object: nil)
        tryAgainLabel.isHidden = true
    }
    
    @objc func playAgain(_ notification: Notification){
        SocketIOHelper.helper.searchForMatch()
    }
    
   
    
    @objc func textFieldReturned(_ notification: Notification) {
        guard let gameString = notification.object as? String else {
            return
        }
        self.friendGameString = gameString
        
        tryAgainLabel.isHidden = true
        gameCodeMenu.isHidden = true
        gameLobbyContainer.isHidden = false
        gameCodeLabel.text = "Game Code: \(gameString)"
        NotificationCenter.default.post(name: .hideTextField, object: nil)
        
        if isFriendGameCreate {
            waitingForHostLabel.isHidden = true
            startFriendGameButton.isHidden = false
        } else {
            waitingForHostLabel.isHidden = false
            startFriendGameButton.isHidden = true
        }
         
    }
    
    @objc func gameNameTaken(_ notification: Notification) {
        if isFriendGameCreate {
            playWithFriendsInfoLabel.text = "Game Code Taken"
        } else {
            playWithFriendsInfoLabel.text = "Game Code Doesn't Exist"
        }
        tryAgainLabel.isHidden = false
        
    }
    
    @objc func updateFriendRoom(_ notification: Notification) {
        guard let numInRoom = notification.object as? Int else {
            return
        }
        if numInRoom == 2 {
            player2Indicator.text = "Player 2 Joined"
            player2Indicator.fontColor = UIColor(rgb: 0x7CFF55)
        } else if numInRoom == 3 {
            player2Indicator.text = "Player 2 Joined"
            player2Indicator.fontColor = UIColor(rgb: 0x7CFF55)
            player3Indicator.text = "Player 3 Joined"
            player3Indicator.fontColor = UIColor(rgb: 0x7CFF55)
            
            
            startFriendGameButton.texture = SKTexture(imageNamed: "playGameButton")
        }
    }
    
    @objc func serverTimedOut(_ notification: Notification){
        if currentlyConnected {
         notConnectedToServerSprite.run(SKAction.moveBy(x: -(notConnectedToServerSprite.size.width), y: 0, duration: 0.3))
        }
        currentlyConnected = false
        SocketIOHelper.helper.manager.reconnect()
    }
    
    func switchToPortrait() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            if let sceneWithPositions = MenuScene(fileNamed: "MenuScenePhonePortrait") {
                self.size = CGSize(width: 1125, height: 2436 )
                
                title.position = sceneWithPositions.title.position
                title.xScale = sceneWithPositions.title.xScale
                title.yScale = sceneWithPositions.title.yScale
                
                playButton.position = sceneWithPositions.playButton.position
                howToPlayButton.position = sceneWithPositions.howToPlayButton.position
                settingsButton.position = sceneWithPositions.settingsButton.position
                
                searchingForGameSprite.position = sceneWithPositions.searchingForGameSprite.position
                stopSearchingForGameSprite.position = sceneWithPositions.stopSearchingForGameSprite.position
                notConnectedToServerSprite.position = sceneWithPositions.notConnectedToServerSprite.position
                
                background.position = sceneWithPositions.background.position
                background.size = sceneWithPositions.background.size
                
                screenArt.texture = sceneWithPositions.screenArt.texture
                
               
                screenArt.xScale = sceneWithPositions.screenArt.xScale
                
                screenArt.yScale = sceneWithPositions.screenArt.yScale
                
                screenArt.size = sceneWithPositions.screenArt.size
                screenArt.position = sceneWithPositions.screenArt.position
               
                
                /*
                 print("Portrait: Art width: \(screenArt.size.width), Art Height: \(screenArt.size.height)")
                print("Portrait: Art xScale: \(screenArt.xScale)")
                print("Portrait: Art yScale: \(screenArt.yScale)")
                 print("Portrait: Art X: \(screenArt.position.x), Art Y: \(screenArt.position.y)")
                 */
                
                playMenu.position = sceneWithPositions.playMenu.position
                difficultyMenu.position = sceneWithPositions.difficultyMenu.position
                createOrJoinMenu.position = sceneWithPositions.createOrJoinMenu.position
                gameCodeMenu.position = sceneWithPositions.gameCodeMenu.position
                gameLobbyContainer.position = sceneWithPositions.gameLobbyContainer.position
                
                textFieldPlaceholder.position = sceneWithPositions.textFieldPlaceholder.position
                
                
                
                
            }
            
            
            
            
            
            /*
            let centerOfContainers = CGPoint(x: 562.5, y: 1280)
            self.size = CGSize(width: 1125, height: 2436 )
            
            title.position = CGPoint(x: 562.5, y: 1890)
            title.xScale = 1
            title.yScale = 1
            playButton.position = CGPoint(x: 562.5, y: 1425)
            howToPlayButton.position = CGPoint(x: 282.5, y: 1150)
            settingsButton.position = CGPoint(x: 842.5, y: 1150)
            
            searchingForGameSprite.position = CGPoint(x: 1469, y: 180)
            stopSearchingForGameSprite.position = CGPoint(x: 1181.333, y: 260)
            notConnectedToServerSprite.position = CGPoint(x: 1545.5, y: 2222)
            
            background.position = CGPoint(x: 562.5, y: 1218)
            background.size = self.size
            
            //screenArt.texture = SKTexture(imageNamed: "Illustration")
            screenArt.size = CGSize(width: 1125, height: 1066)
            screenArt.xScale = 1
            screenArt.yScale = 1
            screenArt.position = CGPoint(x: 562.5, y: 533)
            
           
            
            playMenu.position = centerOfContainers
            difficultyMenu.position = centerOfContainers
            createOrJoinMenu.position = centerOfContainers
            gameCodeMenu.position = centerOfContainers
            gameLobbyContainer.position = centerOfContainers
            
            textFieldPlaceholder.position = CGPoint(x: 562.5, y: 1360)
            
 */
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            
            /*
            let centerOfContainers = CGPoint(x: 768, y: 1024)
            self.size = CGSize(width: 1536, height: 2048 )
            
            title.position = CGPoint(x: 768, y: 1801)
            title.xScale = 1
            title.yScale = 1
            playButton.position = CGPoint(x: 768, y: 1435)
            playButton.xScale = 1
            playButton.yScale = 1
            howToPlayButton.position = CGPoint(x: 268, y: 1435)
            howToPlayButton.xScale = 1
            howToPlayButton.yScale = 1
            
            settingsButton.position = CGPoint(x: 1268, y: 1435)
            settingsButton.xScale = 1
            settingsButton.yScale = 1
            
            searchingForGameSprite.position = CGPoint(x: 1880, y: 160)
            stopSearchingForGameSprite.position = CGPoint(x: 1625.843, y: 240)
            notConnectedToServerSprite.position = CGPoint(x: 1956.5, y: 1880)
            
            background.position = centerOfContainers
            background.size = self.size
            screenArt.position = CGPoint(x: 1536, y: 1397.261)
            screenArt.xScale = 1.365
            screenArt.yScale = 1.311
            
            playMenu.position = centerOfContainers
            difficultyMenu.position = centerOfContainers
            createOrJoinMenu.position = centerOfContainers
            gameCodeMenu.position = centerOfContainers
            gameLobbyContainer.position = centerOfContainers
            
            textFieldPlaceholder.position = CGPoint(x: 768, y: 1024)
            */
            
        }
        
    }
    
    func switchToLandscape() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let sceneWithPositions = MenuScene(fileNamed: "MenuScenePhoneLand") {
                self.size = CGSize(width: 2436, height: 1125 )
                
                title.position = sceneWithPositions.title.position
                title.xScale = sceneWithPositions.title.xScale
                title.yScale = sceneWithPositions.title.yScale
                
                playButton.position = sceneWithPositions.playButton.position
                howToPlayButton.position = sceneWithPositions.howToPlayButton.position
                settingsButton.position = sceneWithPositions.settingsButton.position
                
                searchingForGameSprite.position = sceneWithPositions.searchingForGameSprite.position
                stopSearchingForGameSprite.position = sceneWithPositions.stopSearchingForGameSprite.position
                notConnectedToServerSprite.position = sceneWithPositions.notConnectedToServerSprite.position
                
                background.position = sceneWithPositions.background.position
                background.size = sceneWithPositions.background.size
                
                screenArt.texture = sceneWithPositions.screenArt.texture


                screenArt.xScale = sceneWithPositions.screenArt.xScale
               
                screenArt.yScale = sceneWithPositions.screenArt.yScale
                screenArt.size = sceneWithPositions.screenArt.size
                screenArt.position = sceneWithPositions.screenArt.position
                
                
                /*
                print("Land: Art width: \(screenArt.size.width), Art Height: \(screenArt.size.height)")
                 print("Land: Art xScale: \(screenArt.xScale)")
                print("Land: Art yScale: \(screenArt.yScale)")
                print("Land: Art X: \(screenArt.position.x), Art Y: \(screenArt.position.y)")
                */
                
                
                playMenu.position = sceneWithPositions.playMenu.position
                difficultyMenu.position = sceneWithPositions.difficultyMenu.position
                createOrJoinMenu.position = sceneWithPositions.createOrJoinMenu.position
                gameCodeMenu.position = sceneWithPositions.gameCodeMenu.position
                gameLobbyContainer.position = sceneWithPositions.gameLobbyContainer.position
                
                textFieldPlaceholder.position = sceneWithPositions.textFieldPlaceholder.position
                
                
                
                
            }
            
            
            
            
            /*
            let centerOfContainers = CGPoint(x: 1218, y: 562.5)
            self.size = CGSize(width: 2436, height: 1125 )
            
            title.position = CGPoint(x: 1218, y: 927.4)
            title.xScale = 0.8
            title.yScale = 0.8
            playButton.position = CGPoint(x: 1218, y: 620)
            howToPlayButton.position = CGPoint(x: 2018, y: 620)
            settingsButton.position = CGPoint(x: 418, y: 620)
            
            searchingForGameSprite.position = CGPoint(x: 2780, y: 105)
            notConnectedToServerSprite.position = CGPoint(x: 2856.5, y: 1000)
            stopSearchingForGameSprite.position = CGPoint(x: 2524.333, y: 185)
            
            background.position = centerOfContainers
            background.size = self.size
            
            //screenArt.texture = SKTexture(imageNamed: "landscapeIllustration")
            screenArt.position = CGPoint(x: 1218, y: 265.2)
            screenArt.size = CGSize(width: 1973.4, height: 530.4)
            screenArt.xScale = 1.3
            screenArt.yScale = 1.3
            
            playMenu.position = centerOfContainers
            difficultyMenu.position = centerOfContainers
            createOrJoinMenu.position = centerOfContainers
            gameCodeMenu.position = centerOfContainers
            gameLobbyContainer.position = centerOfContainers
            
            textFieldPlaceholder.position = CGPoint(x: 1218, y: 562.5)
            
 */
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            /*
            let centerOfContainers = CGPoint(x: 1024, y: 768)
            self.size = CGSize(width: 2048, height: 1536 )
            
            
            
            title.position = CGPoint(x: 1024, y: 1313.7)
            title.yScale = 0.9
            title.xScale = 0.9
            
            playButton.position = CGPoint(x: 1024, y: 935)
            playButton.xScale = 1.4
            playButton.yScale = 1.4
            howToPlayButton.position = CGPoint(x: 324, y: 935)
            howToPlayButton.xScale = 1.4
            howToPlayButton.yScale = 1.4
            settingsButton.position = CGPoint(x: 1724, y: 935)
            settingsButton.xScale = 1.4
            settingsButton.yScale = 1.4
            
            searchingForGameSprite.position = CGPoint(x: 2392, y: 165)
            notConnectedToServerSprite.position = CGPoint(x: 2468.5, y: 1420)
            stopSearchingForGameSprite.position = CGPoint(x: 2136.531, y: 245)
            
            background.position = centerOfContainers
            background.size = self.size
            background.xScale = 1.824
            background.yScale = 0.642
            screenArt.position = CGPoint(x: 1021.295, y: 428.534)
            
            
            
            playMenu.position = centerOfContainers
            difficultyMenu.position = centerOfContainers
            createOrJoinMenu.position = centerOfContainers
            gameCodeMenu.position = centerOfContainers
            gameLobbyContainer.position = centerOfContainers
            
            textFieldPlaceholder.position = centerOfContainers
            */
        }
        
    }
    
    func adjustGraphics(){
        if !(UIDevice.current.hasTopNotch && UIDevice.current.userInterfaceIdiom == .phone) {
            notConnectedToServerSprite.position.y -= 170
            searchingForGameSprite.position.y += 170
            stopSearchingForGameSprite.position.y += 170
            print("adjusted Graphics for Non-Notch deviced ")
        }
        print("Adjusted no Graphics")
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
                if UIDevice.current.hasTopNotch {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhoneLand"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "PhoneLand"
                    } else {
                        return nil
                    }
                } else {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "NoNotchLand"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "NoNotchLand"
                    } else {
                        return nil
                    }
                }
            } else if UIDevice.current.orientation.isPortrait {
                if UIDevice.current.hasTopNotch {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                    } else {
                        return nil
                    }
                } else {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "NoNotchPortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "NoNotchPortrait"
                    } else {
                        return nil
                    }
                }
                
            } else if UIDevice.current.orientation.isFlat {
                if UIDevice.current.hasTopNotch {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                    } else {
                        return nil
                    }
                } else {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "NoNotchPortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "NoNotchPortrait"
                    } else {
                        return nil
                    }
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
    
    func stopSearchingForGame(){
        SocketIOHelper.helper.stopSearchForMatch()
    }
    
    @objc func playSoloGameAgain(_ notification: Notification){
        difficultyMenu.isHidden = false
        playMenu.isHidden = true
    }
    
    @objc func removedFromQueue(_ notification: Notification){
        searchingForGameSprite.run(SKAction.moveBy(x: (searchingForGameSprite.size.width), y: 0, duration: 0.3))
        stopSearchingForGameSprite.run(SKAction.moveBy(x: (searchingForGameSprite.size.width + 20), y: 0, duration: 0.3))
        
        searchingForMatch = false
        
        playWithFriendsButton.texture = SKTexture(imageNamed: "playWithFriendsButton")
        playSoloButton.texture = SKTexture(imageNamed: "playSoloButton")
        
    }
        
        
    
    @objc func joinedQueue(_ notification: Notification) {
        searchingForGameSprite.run(SKAction.moveBy(x: -(searchingForGameSprite.size.width), y: 0, duration: 0.3))
        stopSearchingForGameSprite.run(SKAction.moveBy(x: -(searchingForGameSprite.size.width + 20), y: 0, duration: 0.3))
        
        playWithFriendsButton.texture = SKTexture(imageNamed: "playWithFriendsButtonInactive")
        playSoloButton.texture = SKTexture(imageNamed: "playSoloButtonInactive")
        
        searchingForMatch = true
        
        
    }
    
    @objc func alreadyInQueue(_ notification: Notification) {
        
    }
    @objc func connectedToServer( _ notification: Notification) {
        if !currentlyConnected {
            notConnectedToServerSprite.run(SKAction.moveBy(x: notConnectedToServerSprite.size.width, y: 0, duration: 0.3))
        }
        currentlyConnected = true
    }
}

/*
extension SKScene {
    
}
*/
extension UIDevice {
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }
}
