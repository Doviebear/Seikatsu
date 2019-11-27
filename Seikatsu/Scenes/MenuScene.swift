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
    var IDWLogo: SKSpriteNode!
    
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
    
    var settingsContainer: SKSpriteNode!
    var muteButton: SKSpriteNode!
    var isMutedSprite: SKSpriteNode!
    
    var isFriendGameCreate: Bool!
    var friendGameString: String!
    var loadingSprite: SKSpriteNode!
    
    var currentlyConnected = true
    var backgroundMusic: SKAudioNode!
    
    var playIntroLogo = false
    
    var creditsButton: SKSpriteNode!
    var creditsContainer: SKSpriteNode!
    var creditsTitle: SKLabelNode!
    var creditsBody1: SKLabelNode!
    var creditsBody2: SKLabelNode!
    
    var creditsText = """
Game Designers:
Matt Loomis and Isaac Shalev
Game Design Manager:
Daryl Andrews
Art Direction:
Jerry Bennington, Kyle Merkley, Sam Barlin, and Adam Nussdorfer
Artwork:
Peter Wocken, Lucas Mendonca, Sam Barlin, and Adam Nussdorfer
Graphic Designer:
Peter Wocken Design
Editing:
Jerry Bennington, Spencer Reeve, Kyle Merkley, and Dustin Schwartz
"""
    var creditsText2 = """
App Designer:
Dovie Shalev
Producer:
Kuty Shalev
Product Development:
Jerry Bennington and Daryl Andrews
Product Management:
Shauna Monteforte
"""
    
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
        IDWLogo = self.childNode(withName: "IDWLogo") as? SKSpriteNode
        
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
        
        settingsContainer = self.childNode(withName: "settingsContainer") as? SKSpriteNode
        muteButton = settingsContainer.childNode(withName: "muteButton") as? SKSpriteNode
        isMutedSprite = muteButton.childNode(withName: "isMutedSprite") as? SKSpriteNode
        
        
        creditsButton = self.childNode(withName: "creditsButton") as? SKSpriteNode
        creditsContainer = self.childNode(withName: "creditsContainer") as? SKSpriteNode
        creditsTitle = creditsContainer.childNode(withName: "creditsTitle") as? SKLabelNode
        creditsBody1 = creditsContainer.childNode(withName: "creditsBody1") as? SKLabelNode
        creditsBody2 = creditsContainer.childNode(withName: "creditsBody2") as? SKLabelNode
        
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(muteMusic(_:)), name: .muteAllMusic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unmuteMusic(_:)), name: .unmuteAllMusic, object: nil)
       
        
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
        
        /*
        
        if let musicURL = Bundle.main.url(forResource: "title1", withExtension: "wav") {
            let bg = SKAudioNode(url: musicURL)
            addChild(bg)
//            backgroundMusic = bg
            print("Found music")
        } else {
            print("Couldn't find music")
        }
         
         */
        creditsBody1.text = nil
        creditsBody1.attributedText = parseCreditsBody(creditsBody: creditsText)
        creditsBody1.preferredMaxLayoutWidth = creditsContainer.size.width/2 - 50
        
        creditsBody2.text = nil
        creditsBody2.attributedText = parseCreditsBody(creditsBody: creditsText2)
        creditsBody2.preferredMaxLayoutWidth = creditsContainer.size.width/2 - 50
        
    }
    
    func parseCreditsBody(creditsBody: String) -> NSMutableAttributedString {
       
        let titleAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "MyriadPro-Black", size: 36) ]
        let namesAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "MyriadPro-Black", size: 36)]
        
        var newString = NSMutableAttributedString(string: "")
        let stringArray = creditsBody.split(separator: "\n")
        for (index,string) in stringArray.enumerated() {
            if index % 2 == 0 {
                let titleString = NSAttributedString(string: String(string), attributes: titleAttributes)
                newString.append(titleString)
                newString.append(NSAttributedString(string:" "))
            } else {
                let namesString = NSAttributedString(string: String(string), attributes: namesAttributes)
                newString.append(namesString)
                newString.append(NSAttributedString(string:"\n"))
            }
        }
        
        return newString
    }
    
    func playIntro() {
        if playIntroLogo {
            IDWLogo.isHidden = false
            background.zPosition = 100
            IDWLogo.alpha = 0.0
            let fadeIn = SKAction.fadeIn(withDuration: 1.0)
            let soundBite = SKAction.run(
            {
                print("running soundbite")
                if let logoMusicURL = Bundle.main.url(forResource: "SeikatsuLogoJingle", withExtension: "wav") {
                    let logoMusic = SKAudioNode(url: logoMusicURL)
                    logoMusic.autoplayLooped = false
                    self.addChild(logoMusic)
                    print("playing Logo Music")
                } else {
                    print("Couldn't get Logo Music")
                }
            })
            let wait = SKAction.wait(forDuration: 2.0)
            let fadeOut = SKAction.fadeOut(withDuration: 1.0)
            let sequence = SKAction.sequence([fadeIn,soundBite,wait,fadeOut])
            
            IDWLogo.run(sequence) {
                self.background.zPosition = -10
                self.IDWLogo.isHidden = true
                
                if let musicURL = Bundle.main.url(forResource: "title_v2", withExtension: "wav") {
                    let bg = SKAudioNode(url: musicURL)
                    self.addChild(bg)
                    self.backgroundMusic = bg
                    print("Found music")
                } else {
                    print("Couldn't find music")
                }
            }
            playIntroLogo = false
        } else {
            if let musicURL = Bundle.main.url(forResource: "title_v2", withExtension: "wav") {
                let bg = SKAudioNode(url: musicURL)
                self.addChild(bg)
                self.backgroundMusic = bg
                print("Found music")
            } else {
                print("Couldn't find music")
            }
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
                } else if node.name == "creditsButton" {
                    creditsButton.texture = SKTexture(imageNamed: "questionmarkButtonPressed")
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
                    settingsContainer.isHidden = false
                    touchBufferNode.isHidden = false
                    return
                } else if node.name == "muteButton" || node.name == "isMutedSprite" {
                    if isMutedSprite.isHidden == true {
                        NotificationCenter.default.post(name: .muteAllMusic, object: nil)
                        isMutedSprite.isHidden = false
                    } else {
                        NotificationCenter.default.post(name: .unmuteAllMusic, object: nil)
                        isMutedSprite.isHidden = true
                    }
                    
                } else if node.name == "creditsButton" {
                    creditsButton.texture = SKTexture(imageNamed: "questionmarkButton")
                    creditsContainer.isHidden = false
                    touchBufferNode.isHidden = false
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
        settingsContainer.isHidden = true
        creditsContainer.isHidden = true
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
    
    @objc func muteMusic(_ notification: Notification) {
        let mute = SKAction.changeVolume(to: 0.0, duration: 0.1)
        backgroundMusic.run(mute)
        isMutedSprite.isHidden = true
    }
    
    @objc func unmuteMusic(_ notification: Notification) {
        let unmute = SKAction.changeVolume(to: 1.0, duration: 0.0)
        backgroundMusic.run(unmute)
        isMutedSprite.isHidden = false
        
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
                
                touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
                touchBufferNode.size = self.size
                
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
                settingsContainer.position = sceneWithPositions.settingsContainer.position
                
                textFieldPlaceholder.position = sceneWithPositions.textFieldPlaceholder.position
                
                creditsButton.position = sceneWithPositions.creditsButton.position
                creditsContainer.position = sceneWithPositions.creditsContainer.position
                
                
                
                
            } else {
                print("Couldn't get Scene For Transition")
            }
            
            
            
            
            
          
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            
      
            
        }
        
    }
    
    func switchToLandscape() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let sceneWithPositions = MenuScene(fileNamed: "MenuScenePhoneLand") {
                self.size = CGSize(width: 2436, height: 1125 )
                
                touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
                touchBufferNode.size = self.size
                
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
                settingsContainer.position = sceneWithPositions.settingsContainer.position
                
                textFieldPlaceholder.position = sceneWithPositions.textFieldPlaceholder.position
                
                creditsButton.position = sceneWithPositions.creditsButton.position
                creditsContainer.position = sceneWithPositions.creditsContainer.position
                
                
                
                
            } else {
                print("Couldn't get Scene For Transition")
            }
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            if let sceneWithPositions = MenuScene(fileNamed: "MenuScenePadLand") {
                self.size = CGSize(width: 2048 , height: 1536 )
                
                touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
                touchBufferNode.size = self.size
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
                settingsContainer.position = sceneWithPositions.settingsContainer.position
                
                textFieldPlaceholder.position = sceneWithPositions.textFieldPlaceholder.position
                
                creditsButton.position = sceneWithPositions.creditsButton.position
                creditsContainer.position = sceneWithPositions.creditsContainer.position
                
                
                
            } else {
                print("Couldn't get Scene For Transition")
            }
            
            
        }
        
    }
    
    func adjustGraphics(){
        if !(UIDevice.current.hasTopNotch && UIDevice.current.userInterfaceIdiom == .phone) {
            notConnectedToServerSprite.position.y -= 200
            searchingForGameSprite.position.y += 200
            stopSearchingForGameSprite.position.y += 200
            creditsButton.position.y += 200
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
