//
//  singleplayerGameScene.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 10/17/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation
import GameplayKit

//
//  GameSceneOnline.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 8/7/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//
// custom font name: "MyriadPro-Black"

import UIKit
import GameplayKit

 class singleplayerGameScene: SKScene {
    var model: GameModel!
    var tokensInPlay = [tokenNode]()
    var tokenSpacesInPlay = [TokenSpace]()
    var playerTokenNodesInPlay = [tokenNode]()
    // 0 is new turn start, 1 is picked from hand
    var gameplayPhase = 0
    var selectedToken: tokenNode?
    var selectedTokenSpace: TokenSpace?
    var selectedTokenOldPosistion: CGPoint?
    var effectNodesInPlay = [SKSpriteNode]()
    var localPlayerOneScore = 0 {
        didSet {
            localPlayerOneScoreLabel.text = "\(localPlayerOneScore)"
        }
    }
    var localPlayerTwoScore = 0 {
        didSet {
            localPlayerTwoScoreLabel.text = "\(localPlayerTwoScore)"
        }
    }
    
    var koiPonds = [Token]()
    var rowScores = [[Int]]()
  
    

    var localPlayerOneScoreLabel: SKLabelNode!
    var localPlayerTwoScoreLabel: SKLabelNode!
   
    
    var scoreBoard: SKSpriteNode!
    var scoreBarContainerTemplate: SKSpriteNode!
    var scoreBars = [SKSpriteNode]()
    
    var touchBufferNode: SKSpriteNode!
    
    
    var centerHexagon: SKSpriteNode!
    var playerNum: Int!
    var sksPlayerTokenNodes = [SKSpriteNode]()
    var yourTurnIndicator: SKSpriteNode!
    
    var hamburgerButton: SKSpriteNode!
    
    var menuContainer: SKSpriteNode!
    var quitButton: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    var resumeButton: SKSpriteNode!
    
    var gameBoard: SKSpriteNode!
    var tilesBackground: SKSpriteNode!
    
    var checkmark: SKSpriteNode!
    var cross: SKSpriteNode!
    var pointsFromTilesLabel: SKLabelNode!
    var pointsFromRowsLabel: SKLabelNode!
    
    var playAgainButton: SKSpriteNode!
    var mainMenuButton: SKSpriteNode!
    var endGameContainer: SKSpriteNode!
    var finalScoreLabel: SKLabelNode!
    var winnerLabel: SKLabelNode!
    
    var locationOfLastTile: Location!
    var lastPlayedTokenNode: tokenNode!
    
    var difficulty: String!
    var playerRowsArray: [[[Location]]]!
    
    var settingsContainer: SKSpriteNode!
    var muteButton: SKSpriteNode!
    var isMutedSprite: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    
    //Player One: Pink
    //Player Two: Blue
    //Player Three: Green
    
    convenience init?(fileNamed: String, gameModel: GameModel, difficulty: String){
      
        self.init(fileNamed: fileNamed)
       
        self.scaleMode = .aspectFill
        self.model = gameModel
        self.playerNum = 1
        self.difficulty = difficulty
       
        
        makeStartingPeices()
        makePlayerLocationArrays()
        startTurn()
    }
    
    
    
    
    
    
    ///Gameplay Functions
    
    func startTurn() {
        
        for tokenNode in self.playerTokenNodesInPlay {
            tokenNode.removeFromParent()
        }
        self.playerTokenNodesInPlay.removeAll()
        for effectNode in self.effectNodesInPlay {
            effectNode.removeFromParent()
        }
        self.effectNodesInPlay.removeAll()
        
        
        
        for (index,token) in model.playerOneHand.enumerated() {
            let nodeOfToken = tokenNode(token: token)
            let posistionOfNode = sksPlayerTokenNodes[index].position
            let sizeOfToken = sksPlayerTokenNodes[index].size
            nodeOfToken.sprite!.size = sizeOfToken
            nodeOfToken.placeTokenNode(in: posistionOfNode, on: self)
            playerTokenNodesInPlay.append(nodeOfToken)
            if model.playerTurn == playerNum {
                addTouchableEffectSprite(in: posistionOfNode, with: sizeOfToken)
            }
            
        }
        
        updateScore(player: 1, setAt: model.playerOneScore)
        updateScore(player: 2, setAt: model.playerTwoScore)
    }
    
    
    func roundEndStuff() {
        winnerLabel.fontName = "MyriadPro-Black"
        let winningPlayer = checkForWinner()
        if winningPlayer == playerNum {
            winnerLabel.text = "You Win!"
        } else {
            winnerLabel.text = "Player \(winningPlayer) Wins!"
        }
        
        finalScoreLabel.fontName = "MyriadPro-Black"
       
            finalScoreLabel.text = "You Score is: \(localPlayerOneScore)"
       
        
        endGameContainer.isHidden = false
        gameplayPhase = 10
        
        return
    }
    
    
    
    
    
    
    
    func makeStartingPeices() {
        print("Function makeStartingPeices started")
        
        self.scoreBoard = self.childNode(withName: "scoreBoard") as? SKSpriteNode
        self.localPlayerOneScoreLabel = scoreBoard.childNode(withName: "localPlayerOneScoreLabel") as? SKLabelNode
        self.localPlayerTwoScoreLabel = scoreBoard.childNode(withName: "localPlayerTwoScoreLabel") as? SKLabelNode
        self.scoreBarContainerTemplate = scoreBoard.childNode(withName: "scoreBarContainerTemplate") as? SKSpriteNode
        for num in 1...2 {
            let scoreBarString = "scoreBar" + String(num)
            if let scoreBar = scoreBoard.childNode(withName: scoreBarString) as? SKSpriteNode {
                scoreBars.append(scoreBar)
            }
        }
        
        self.yourTurnIndicator = self.childNode(withName: "yourTurnIndicator") as? SKSpriteNode
        self.hamburgerButton = self.childNode(withName: "hamburgerButton") as? SKSpriteNode
        self.gameBoard = self.childNode(withName: "gameBoard") as? SKSpriteNode
        self.tilesBackground = self.childNode(withName: "tilesBackground") as? SKSpriteNode
        
        self.settingsContainer = self.childNode(withName: "settingsContainer") as? SKSpriteNode
        self.muteButton = settingsContainer.childNode(withName: "muteButton") as? SKSpriteNode
        self.isMutedSprite = muteButton.childNode(withName: "isMutedSprite") as? SKSpriteNode
        
        self.menuContainer = self.childNode(withName: "menuContainer") as? SKSpriteNode
        self.resumeButton = menuContainer.childNode(withName: "resumeButton") as? SKSpriteNode
        self.quitButton = menuContainer.childNode(withName: "quitButton") as? SKSpriteNode
        self.howToPlayButton = menuContainer.childNode(withName: "howToPlayButton") as? SKSpriteNode
        self.settingsButton = menuContainer.childNode(withName: "settingsButton") as? SKSpriteNode
        self.checkmark = self.childNode(withName: "checkmark") as? SKSpriteNode
        self.cross = self.childNode(withName: "cross") as? SKSpriteNode
        self.pointsFromTilesLabel = self.childNode(withName: "pointsFromTilesLabel") as? SKLabelNode
        self.pointsFromRowsLabel = self.childNode(withName: "pointsFromRowsLabel") as? SKLabelNode
        self.endGameContainer = self.childNode(withName: "endGameContainer") as? SKSpriteNode
        
        self.winnerLabel = endGameContainer.childNode(withName: "winnerLabel") as? SKLabelNode
        
        self.finalScoreLabel = endGameContainer.childNode(withName: "finalScoreLabel") as? SKLabelNode
        self.playAgainButton = endGameContainer.childNode(withName: "playAgainButton") as? SKSpriteNode
        self.mainMenuButton = endGameContainer.childNode(withName: "mainMenuButton") as? SKSpriteNode
        
        for token in model.playerTwoHand {
            model.grabBag.tokens.append(token)
            token.player = nil
        }
        for token in model.playerThreeHand {
            model.grabBag.tokens.append(token)
            token.player = nil
        }
        model.playerTwoHand.removeAll()
        model.playerThreeHand.removeAll()
        
        
        
        
        model.grabBag.tokens.append(model.playerOneHand[1])
        model.playerOneHand[1].player = nil
        model.playerOneHand.remove(at: 1)
        for _ in 1...4 {
            for (index,token) in model.grabBag.tokens.enumerated() {
                //print("index is: \(index)")
                if token.birdType == "pond" {
                    koiPonds.append(token)
                    model.grabBag.tokens.remove(at: index)
                    break
                }
            }
        }
        if model.playerOneHand[0].birdType == "pond" {
            let koiPond = model.playerOneHand.remove(at: 0)
            koiPonds.append(koiPond)
            drawNewToken(for: 1)
            
        }
        
        
        
        if  let firstKoiPond = koiPonds.popLast() {
            model.playerOneHand.append(firstKoiPond)
            firstKoiPond.player = 1
        }
        
        
        for onlineToken in model.TokensInPlay {
            var match = false
            for localToken in self.tokensInPlay {
                
                if onlineToken == localToken.tokenData{
                    match = true
                    print("Found match")
                    break
                }
            }
            if match == false {
                print("Didn't find match, creating piece")
                let tokenToPlace = tokenNode(token: onlineToken, sizingHexagon: centerHexagon)
                tokensInPlay.append(tokenToPlace)
                let positionToPut = getPositionOfTokenSpace(at: onlineToken.Location!)
                tokenToPlace.placeTokenNode(in: positionToPut!, on: self)
            }
            
        }
        for tokenSpace in self.tokenSpacesInPlay {
                   for token in self.tokensInPlay {
                       if token.tokenData.Location == tokenSpace.Location {
                           removeTokenSpace(at: tokenSpace.Location)
                       }
                   }
               }
       
        
        print("num Of Ponds \(koiPonds.count)")
        print("num in Grabbag: \(model.grabBag.tokens.count)")
        print("Function MakeStartingPieces Ended")
    }
    
    override func sceneDidLoad() {
         print("Function SceneDidLoad started")

        self.centerHexagon = self.childNode(withName: "//centerHexagon") as? SKSpriteNode
        print("Screen Width: \(JKGame.rect.width)")
        print("Screen Height: \(JKGame.rect.height)")
        for i in 1...2 {
            for k in 1...4 {
                var col = 1
                if i == 2 {
                    col = 7
                }
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k + 1), textureName: "circleNode")
                tokenSpace.drawNode(on: self, in: centerHexagon)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        for i in 1...2 {
            for k in 1...5 {
                var col = 2
                if i == 2 {
                    col = 6
                }
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k + 1), textureName: "circleNode")
                tokenSpace.drawNode(on: self, in: centerHexagon)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        for i in 1...2 {
            for k in 1...6 {
                var col = 3
                if i == 2 {
                    col = 5
                }
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k ), textureName: "circleNode")
                tokenSpace.drawNode(on: self, in: centerHexagon)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        for k in 1...7 {
            let col = 4
            if k != 4 {
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k), textureName: "circleNode")
                tokenSpace.drawNode(on: self, in: centerHexagon)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        self.sksPlayerTokenNodes.append(self.childNode(withName: "PlayerToken1") as! SKSpriteNode)
        self.sksPlayerTokenNodes.append(self.childNode(withName: "PlayerToken2") as! SKSpriteNode)
        
        for token in sksPlayerTokenNodes {
            token.removeFromParent()
        }
       
        
        
       
        
        
        for _ in 0...2 {
            let arrayOfScores = [0,0,0,0,0,0,0]
            rowScores.append(arrayOfScores)
        }
        
        
        touchBufferNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.5),size:self.size)
        touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        touchBufferNode.zPosition = 100
        touchBufferNode.isHidden = true
        touchBufferNode.name = "touchBufferNode"
        addChild(touchBufferNode)
        
        
        
        if let musicURL = Bundle.main.url(forResource: "gameplay1", withExtension: "wav") {
            self.backgroundMusic = SKAudioNode(url: musicURL)
            //                    self.backgroundMusic = bg
            if UserDefaultsHelper.helper.getDefaultBool(key: "musicMuted") {
                
                let mute = SKAction.changeVolume(to: 0.0, duration: 0.0)
                self.backgroundMusic.run(mute)
                //self.isMutedSprite.isHidden = true
                if let sprite = self.isMutedSprite {
                    sprite.isHidden = false
                } else {
                 print("Couldn't get isMutedSprite")
                }
            }
            
            self.addChild(self.backgroundMusic)
            
            print("Found Music")
        } else {
            print("Couldn't find music")
        }
        
        
         print("Function SceneDidLoad Ended")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if node.name == "hamburgerButton" {
                    hamburgerButton.texture = SKTexture(imageNamed: "hamburgerButtonPressed")
                } else if node.name == "settingsButton" {
                    settingsButton.texture = SKTexture(imageNamed: "settingsButtonPressed")
                } else if node.name == "quitButton" {
                    quitButton.texture = SKTexture(imageNamed: "quitGameButtonPressed")
                } else if node.name == "howToPlayButton" {
                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButtonPressed")
                } else if node.name == "resumeButton" {
                    resumeButton.texture = SKTexture(imageNamed: "resumeButtonPressed")
                } else if node.name == "playAgainButton" {
                    playAgainButton.texture = SKTexture(imageNamed: "playAgainButtonPressed")
                } else if node.name == "mainMenuButton" {
                    mainMenuButton.texture = SKTexture(imageNamed: "mainMenuButtonPressed")
                }
            }
        }
    }
    
    func makePlayerLocationArrays(){
        // Top Left Down
        let player1RowsInt = [[[4,1,1],[3,1,1],[2,1,2],[1,1,2]],[[5,1,1],[4,2,2],[3,2,2],[2,2,3],[1,2,3]],[[6,1,2],[5,2,2],[4,3,3],[3,3,3],[2,3,4],[1,3,4]],[[7,1,2],[6,2,3],[5,3,3],[3,4,4],[2,4,5],[1,4,5]],[[7,2,3],[6,3,4],[5,4,4],[4,5,5],[3,5,5],[2,5,6]],[[7,3,4],[6,4,5],[5,5,5],[4,6,6],[3,6,6]],[[7,4,5],[6,5,6],[5,6,6],[4,7,7]]]
        
        //Top Right Down
        let player2RowsInt = [[[4,1,1],[5,1,1],[6,1,2],[7,1,2]],[[3,1,1],[4,2,2],[5,2,2],[6,2,3],[7,2,3]],[[2,1,2],[3,2,2],[4,3,3],[5,3,3],[6,3,4],[7,3,4]],[[1,1,2],[2,2,3],[3,3,3],[5,4,4],[6,4,5],[7,4,5]],[[1,2,3],[2,3,4],[3,4,4],[4,5,5],[5,5,5],[6,5,6]],[[1,3,4],[2,4,5],[3,5,5],[4,6,6],[5,6,6]],[[1,4,5],[2,5,6],[3,6,6,],[4,7,7]]]
        
        //Stright down
        let player3RowsInt = [[[1,1,2],[1,2,3],[1,3,4],[1,4,5]],[[2,1,2],[2,2,3],[2,3,4],[2,4,5],[2,5,6]],[[3,1,1],[3,2,2],[3,3,3],[3,4,4],[3,5,5],[3,6,6]],[[4,1,1],[4,2,2],[4,3,3],[4,5,5],[4,6,6],[4,7,7]],[[5,1,1],[5,2,2],[5,3,3],[5,4,4],[5,5,5],[5,6,6]],[[6,1,2],[6,2,3],[6,3,4],[6,4,5],[6,5,6]],[[7,1,2],[7,2,3],[7,3,4],[7,4,5]]]
        
        let player1Rows = makeLocationArray(arrayToConvert: player1RowsInt)
        let player2Rows = makeLocationArray(arrayToConvert: player2RowsInt)
        let player3Rows = makeLocationArray(arrayToConvert: player3RowsInt)
        self.playerRowsArray = [player1Rows,player2Rows,player3Rows]
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                
                if node.name == "touchBufferNode" {
                    closeAllContainers()
                    
                }
                
                
                if menuContainer.isHidden == false {
                    if node.name == "settingsButton" {
                        print("Settings button Pressed")
                        settingsButton.texture = SKTexture(imageNamed: "settingsButton")
                        menuContainer.isHidden = true
                        settingsContainer.isHidden = false
                        return
                    } else if node.name == "quitButton" {
                        //quitButton.texture = SKTexture(imageNamed: "quitButton")
                        print("Quit button Pressed")
                        SocketIOHelper.helper.quitMatch()
                        backToMainMenuScene()
                        return
                    } else if node.name == "howToPlayButton" {
                        print("HowToPlay button Pressed")
                        if let youtubeURL = URL(string: "youtube://01nTfTLFThA&"),
                            UIApplication.shared.canOpenURL(youtubeURL) {
                            // redirect to app
                            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=01nTfTLFThA&") {
                            // redirect through safari
                            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                        }
                        
                        howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButton")
                        menuContainer.isHidden = true
                        return
                    } else if node.name == "resumeButton" {
                        print("Resume button Pressed")
                        resumeButton.texture = SKTexture(imageNamed: "resumeButton")
                        closeAllContainers()
                        return
                    }
                } else if settingsContainer.isHidden == false {
                    if node.name == "muteButton" || node.name == "isMutedSprite" {
                        if isMutedSprite.isHidden == true {
                            NotificationCenter.default.post(name: .muteAllMusic, object: nil)
                            muteMusic()
                            return
                        } else {
                            NotificationCenter.default.post(name: .unmuteAllMusic, object: nil)
                            unmuteMusic()
                            return
                        }
                        
                    }
                }
                    
                    
                
                guard menuContainer.isHidden == true else {
                    return
                }
                
                if node.name == "hamburgerButton" {
                    hamburgerButton.texture = SKTexture(imageNamed: "hamburgerButton")
                    menuContainer.isHidden = false
                    touchBufferNode.isHidden = false
                    return
                }
                
                
                
                if gameplayPhase == 0 {
                    if node.name == "tokenNode" {
                        if let tokenNode = node as? tokenNode {
                            if tokenNode.tokenData.player == nil {
                                return
                            }
                            tokenNodeTouched(node: node, phase: 0)
                        }
                      
                    }
                } else if gameplayPhase == 1 {
                    if node.name == "tokenSpace" {
                        let tokenNd = node as! TokenSpace
                        print("Col is: \(tokenNd.Location.col)")
                        print("Num in Col is: \(tokenNd.Location.numInCol)")
                        print("Pos Num in Col is: \(tokenNd.Location.posistioningNumInCol)")
                        tokenSpaceTouched(node: node, phase: 1)
                    } else if node.name == "tokenNode" {
                        tokenNodeTouched(node: node, phase: 1)
                    }
                } else if gameplayPhase == 2 {
                    print("phase 3 touch")
                    if node.name == "checkmark" {
                        print("checkmark touched in phase 3")
                        removePhaseThreeGraphics()
                        placeToken()
                        return
                    } else if node.name == "cross" {
                        print("cross touched in phase 3")
                        removePhaseThreeGraphics()
                        revertPhaseThreeTokenMovement()
                        gameplayPhase = 1
                        selectedTokenSpace = nil
                        return
                    }
                } else if gameplayPhase == 10 {
                    if node.name == "playAgainButton" {
                        backToMainMenuScene()
                        NotificationCenter.default.post(name: .playSoloGameAgain, object: nil)
                    } else if node.name == "mainMenuButton" {
                        backToMainMenuScene()
                    }
                }
            }
        }
    }
    
    
    func placeToken() {
        if let nodeToPlace = selectedToken {
            selectedTokenOldPosistion = selectedToken?.position
            guard let tokenSpaceNode = selectedTokenSpace else {
                return
            }
            
            nodeToPlace.tokenData.Location = tokenSpaceNode.Location
            
            addScoreFromBirds(tokenNodeToCheck: nodeToPlace)
            
            addRowScore(from: nodeToPlace, for: 1)
            addRowScore(from: nodeToPlace, for: 2)
            addRowScore(from: nodeToPlace, for: 3)
            
            //For You
            
            
            tokensInPlay.append(nodeToPlace)
            model.TokensInPlay.append(nodeToPlace.tokenData)
            nodeToPlace.tokenData.player = nil
            
            removeTokenSpace(at: tokenSpaceNode.Location)
            selectedTokenSpace = nil
            nextTurn()
        }
    }
    //executed when a TokenNode has already been selected and a player taps on a tokenSpace to play the token
    func tokenSpaceTouched(node: SKNode, phase: Int){
        if phase == 1 {
            
            
            if let nodeToPlace = selectedToken {
                
                guard let tokenSpaceNode = node as? TokenSpace else {
                    return
                }
                nodeToPlace.tokenData.Location = tokenSpaceNode.Location
                if nodeToPlace.tokenData.birdType == "pond" {
                    for tokenNode in tokensInPlay {
                        if nodeToPlace.isAdjacent(tokenNode2: tokenNode) {
                            selectedTokenOldPosistion = selectedToken?.position
                            phaseThreeGraphics(nodeToPlace: nodeToPlace, tokenSpace: tokenSpaceNode)
                            selectedTokenSpace = tokenSpaceNode
                            gameplayPhase = 2
                            return
                        }
                    }
                    nodeToPlace.tokenData.Location = nil
                    return
                }
                
                
                if model.turnNum == 0 {
                    let placeholderToken1 = tokenNode(token: Token(flowerType: "placeholder", birdType: "placeholder"))
                    placeholderToken1.tokenData.Location = Location(col: 3, numInCol: 3, posistioningNumInCol: 3)
                    let placeholderToken2 = tokenNode(token: Token(flowerType: "placeholder", birdType: "placeholder"))
                    placeholderToken2.tokenData.Location = Location(col: 5, numInCol: 3, posistioningNumInCol: 3)
                    let placeholderToken3 = tokenNode(token: Token(flowerType: "placeholder", birdType: "placeholder"))
                    placeholderToken3.tokenData.Location = Location(col: 4, numInCol: 5, posistioningNumInCol: 5)
                    if nodeToPlace.isAdjacent(tokenNode2: placeholderToken1) || nodeToPlace.isAdjacent(tokenNode2: placeholderToken2) || nodeToPlace.isAdjacent(tokenNode2: placeholderToken3) {
                        
                        selectedTokenOldPosistion = selectedToken?.position
                        phaseThreeGraphics(nodeToPlace: nodeToPlace, tokenSpace: tokenSpaceNode)
                        selectedTokenSpace = tokenSpaceNode
                        gameplayPhase = 2
                        return
                    } else {
                        nodeToPlace.tokenData.Location = nil
                        return
                    }
                    
                } else {
                    if nodeToPlace.isAdjacent(tokenNode2: lastPlayedTokenNode) {
                        selectedTokenOldPosistion = selectedToken?.position
                        phaseThreeGraphics(nodeToPlace: nodeToPlace, tokenSpace: tokenSpaceNode)
                        selectedTokenSpace = tokenSpaceNode
                        gameplayPhase = 2
                        return
                    } else {
                        nodeToPlace.tokenData.Location = nil
                        return
                    }
                }
        
            } else {
                print("Error: Selected Token Not Found")
            }
        }
    }
    
    //executed when Player turn has ended, after placing new TokenNode
    func nextTurn() {
        model.turnNum += 1
//        let oldPosition = selectedTokenOldPosistion
        
        for (index,token) in model.playerOneHand.enumerated() {
            if token == selectedToken?.tokenData {
                model.playerOneHand.remove(at: index)
            }
        }
        
        for (index, token) in self.playerTokenNodesInPlay.enumerated() {
            if selectedToken?.tokenData == token.tokenData {
                self.playerTokenNodesInPlay.remove(at: index)
            }
        }
        
        
        if selectedToken?.tokenData.birdType == "pond" {
            if let nextKoiPond = koiPonds.popLast() {
                model.playerOneHand.append(nextKoiPond)
                nextKoiPond.player = 1
            }
        } else {
            drawNewToken(for: 1)
        }
        
        
        gameplayPhase = 0
        
        lastPlayedTokenNode = selectedToken
        
        selectedToken = nil
        
        var thereAreValidMoves = false
        
        for tokenSpace in tokenSpacesInPlay {
            if lastPlayedTokenNode.isAdjacentToSpace(tokenSpace: tokenSpace) {
                thereAreValidMoves = true
                break
            }
        }
        
        if koiPonds.count != 0 {
            thereAreValidMoves = true
        }
        
        
        if model.turnNum >= 33 || !thereAreValidMoves {
            endOfRound()
            return
        }
        //Send model up to server
        /*
        print("Player One score in local: \(localPlayerOneScore) ")
        print("Player One score in Online: \(model.playerOneScore) ")
        print("Player Two score in local: \(localPlayerTwoScore)")
        print("Player Two score in Online: \(model.playerTwoScore)")
        print("Player Three score in local: \(localPlayerThreeScore)")
        print("Player Three score in Online: \(model.playerThreeScore) ")
 */
        startTurn()
    }
    
    func tokenNodeTouched(node: SKNode, phase: Int) {
        if phase == 0 {
            let tokenNode = node as? tokenNode
            
            selectedToken = tokenNode
            gameplayPhase = 1
            tokenNode?.xScale = 1.15
            tokenNode?.yScale = 1.15
            tokenNode?.zPosition = 21
            
        } else if phase == 1 {
            let tokenNode = node as? tokenNode
            if tokenNode?.tokenData.player == model.playerTurn {
                if tokenNode === selectedToken {
                    selectedToken = nil
                    tokenNode?.xScale = 1
                    tokenNode?.yScale = 1
                    tokenNode?.zPosition = 20
                    gameplayPhase = 0
                }
            }
        }
    }
    
    func endOfRound() {
        
        let winningPlayer = checkForWinner()
        if winningPlayer == playerNum {
            winnerLabel.text = "You Win!"
        } else {
            winnerLabel.text = "You Lose!"
        }
        finalScoreLabel.text = "You Score is: \(localPlayerOneScore)"
        endGameContainer.isHidden = false
        gameplayPhase = 10
        
        return
        
    }
    
    
    
    func backToMainMenuScene() {
        if let fileName = getFileName() {
            if let scene = MenuScene(fileNamed: fileName) {
                scene.scaleMode = .aspectFill
                NotificationCenter.default.post(name: .changeCurrentScene, object: scene)
                
                self.view?.presentScene(scene)
                scene.playIntro()
                
                self.view?.ignoresSiblingOrder = true
                
                
            } else {
                print("Couldn't create Menu Scene")
            }
            
        } else {
            print("Couldn't get File Name for Menu Scene")
        }
        return
    }
    
    func closeAllContainers() {
        touchBufferNode.isHidden = true
        settingsContainer.isHidden = true
        menuContainer.isHidden = true
    }
    
    func getFileName() -> String? {
        //We call this function with a baseSKSName passed in, and return either a
        //modified name or the same name if no other device specific SKS files are found.
        //For example, if baseSKSName = Level1 and Level1TV.sks exists in the project,
        //then the string returned is Level1TV
        let baseSKSName = "MenuScene"
        var fullSKSNameToLoad:String
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
        return fullSKSNameToLoad
    }
    
    
    
    ///Model Change Functions
    
    
    
    
    
    
    
    //No graphical changes, just updates the model
    func drawNewToken(for player: Int) {
        if model.grabBag.tokens.count <= 0 {
            return
        }
        let token = model.grabBag.drawToken()
        
        
        if player == 1 {
            token.player = 1
            model.playerOneHand.append(token)
        } else if player == 2 {
            token.player = 2
            model.playerTwoHand.append(token)
        } else {
            token.player = 3
            model.playerThreeHand.append(token)
        }
        
    }
    
    
    
    
    
    
    /// Graphical Funcs
    
    func phaseThreeGraphics(nodeToPlace: tokenNode, tokenSpace: TokenSpace){
        nodeToPlace.position = tokenSpace.position
        nodeToPlace.xScale = 1.0
        nodeToPlace.yScale = 1.0
        nodeToPlace.zPosition = 20
        nodeToPlace.sprite?.size = CGSize(width: centerHexagon.size.height/8, height: centerHexagon.size.height/8)
        let topOfNodeToPlace = CGPoint(x: nodeToPlace.position.x ,y: nodeToPlace.position.y + (nodeToPlace.sprite?.size.height)!/2)
        
        
        checkmark.position = CGPoint(x: topOfNodeToPlace.x + (nodeToPlace.sprite?.size.width)!/2 + 30, y: topOfNodeToPlace.y)
        cross.position = CGPoint(x: checkmark.position.x + 150, y: checkmark.position.y)
        checkmark.isHidden = false
        cross.isHidden = false
        
        pointsFromTilesLabel.position = CGPoint(x: nodeToPlace.position.x - (nodeToPlace.sprite?.size.width)!/2 - 25, y: nodeToPlace.position.y)
        pointsFromTilesLabel.text = "+\(getScoreFromBirds(tokenNodeToCheck: nodeToPlace))"
        pointsFromTilesLabel.isHidden = false
        
        pointsFromRowsLabel.position = CGPoint(x: pointsFromTilesLabel.position.x, y: pointsFromTilesLabel.position.y - 50)
        
        let rowToUse = getRowForToken(tokenNode: nodeToPlace, player: playerNum)
        var plusPointsFromRow = getScoreForRowWithTokenAdded( player: playerNum, tokenAdded: nodeToPlace) - rowScores[playerNum - 1][rowToUse - 1]
        if plusPointsFromRow < 0 {
            plusPointsFromRow = 0
        }
            
        pointsFromRowsLabel.text = "+\(plusPointsFromRow)"
        pointsFromRowsLabel.isHidden = false
        
        
        
    }
    
    func removePhaseThreeGraphics(){
            checkmark.isHidden = true
            cross.isHidden = true
          
            pointsFromTilesLabel.isHidden = true
       
            pointsFromRowsLabel.isHidden = true
    }
    
    func revertPhaseThreeTokenMovement(){
        if let nodeToPlace = selectedToken {
            nodeToPlace.position = selectedTokenOldPosistion!
            nodeToPlace.xScale = 1.15
            nodeToPlace.yScale = 1.15
            nodeToPlace.zPosition = 20
            nodeToPlace.sprite?.size = sksPlayerTokenNodes[0].size
            nodeToPlace.tokenData.Location = nil
        }
    }
    
    
    
    func removeTokenSpace(at location: Location) {
        for (index, tokenSpaceToCheck) in tokenSpacesInPlay.enumerated() {
            if tokenSpaceToCheck.Location.col == location.col && tokenSpaceToCheck.Location.numInCol == location.numInCol && tokenSpaceToCheck.Location.posistioningNumInCol == location.posistioningNumInCol {
                tokenSpaceToCheck.removeFromParent()
                tokenSpacesInPlay.remove(at: index)
                break
            }
        }
        
    }
    
    
    
    
    
    
    
    
    /// Scoring Funcs
    func getScoreFromBirds(tokenNodeToCheck: tokenNode) -> Int {
        var adjacentTokens = [tokenNode]()
        for token in tokensInPlay {
            if tokenNodeToCheck.isAdjacent(tokenNode2: token) {
                adjacentTokens.append(token)
            }
        }
        var count = 0
        if tokenNodeToCheck.tokenData.birdType == "pond" {
            var numOfBirds = [0,0,0,0]
            for i in 0...3 {
                for adjacentToken in adjacentTokens {
                    if model.grabBag.birds[i] == adjacentToken.tokenData.birdType {
                        if numOfBirds[i] == 0 {
                            numOfBirds[i] = 1
                        }
                        numOfBirds[i] += 1
                    }
                }
            }
            count = numOfBirds.max()!
        } else {
            for adjacentToken in adjacentTokens {
                if tokenNodeToCheck.tokenData.birdType == adjacentToken.tokenData.birdType && tokenNodeToCheck.tokenData.birdType != "pond" {
                    if count == 0 {
                        count = 1
                    }
                    count += 1
                }
            }
        }
        return count
    }
    
    
    
    func addScoreFromBirds(tokenNodeToCheck: tokenNode) {
        let amountToAdd = getScoreFromBirds(tokenNodeToCheck: tokenNodeToCheck)
        
        // add the score here
        if difficulty == "easy" {
            updateScore(player: 1, amount: amountToAdd)
        } else if difficulty == "medium" {
            return
        } else if difficulty == "hard" {
            updateScore(player: 2, amount: amountToAdd)
        } else {
            print("Error adding score, Player not found")
        }
        
    }
    
    
    func updateScore(player: Int, amount: Int? = nil, setAt: Int? = nil) {
        if let amount = amount {
            if player == 1 {
                model.playerOneScore += amount
                localPlayerOneScore += amount
                moveScoreBars(player: player, score: model.playerOneScore)
            } else if player == 2 {
                model.playerTwoScore += amount
                localPlayerTwoScore += amount
                moveScoreBars(player: player, score: model.playerTwoScore)
            }
            return
        } else if let setAt = setAt {
            if player == 1 {
                model.playerOneScore = setAt
                localPlayerOneScore = setAt
                moveScoreBars(player: player, score: setAt)
            } else if player == 2 {
                model.playerTwoScore = setAt
                localPlayerTwoScore = setAt
                moveScoreBars(player: player, score: setAt)
            } else {
                print("error Updating score, player not found")
            }
            return
        } else {
            print("Errot updating score, both values are nil")
        }
    }
    
    
    func moveScoreBars(player: Int, score: Int) {
        let amountToMoveTo = ((scoreBarContainerTemplate.size.width * CGFloat(0.95)) / CGFloat(80)) * CGFloat(score)
        
        for (index, scoreBar) in scoreBars.enumerated() {
            if index == player - 1 {
                scoreBar.size.width = amountToMoveTo
                break
            }
        }
        
    }
    
    func addTotalScore(from tokenNode: tokenNode, for player: Int) {
        addScoreFromBirds(tokenNodeToCheck: tokenNode, for: player)
        addRowScore(from: tokenNode, for: player)
    }
    
    func addRowScore(from tokenNode: tokenNode, for player: Int){
        let rowPlayer = player
        var scorePlayer = player
        if player == 3 {
            scorePlayer = 2
        }
        let rowToUse = getRowForToken(tokenNode: tokenNode, player: rowPlayer)
        let scoreForRow = getScoreForRowWithTokenAdded( player: rowPlayer, tokenAdded: tokenNode)
        print("The total Score for this row is: \(scoreForRow)")
        print("Row score that has already been accounted for is: \(rowScores[player - 1][rowToUse - 1])")
        
        var plusPointsFromRow = getScoreForRowWithTokenAdded( player: rowPlayer, tokenAdded: tokenNode) - rowScores[rowPlayer - 1][rowToUse - 1]
        if plusPointsFromRow < 0 {
            plusPointsFromRow = 0
        }
        updateScore(player: scorePlayer, amount: plusPointsFromRow)
        rowScores[rowPlayer - 1][rowToUse - 1] += plusPointsFromRow
        model.rowScores = rowScores
        
    }
    
    func addScoreFromBirds(tokenNodeToCheck: tokenNode, for player: Int) {
        let amountToAdd = getScoreFromBirds(tokenNodeToCheck: tokenNodeToCheck)
        updateScore(player: player, amount: amountToAdd)
    }
    
    
    func getScoreForRowWithTokenAdded(player: Int, tokenAdded: tokenNode) -> Int {
        //Stright down
        
        
        let playerArrayToCheck = playerRowsArray[player - 1]
        let row = getRowForToken(tokenNode: tokenAdded, player: player)
        let locationArrayToCheck = playerArrayToCheck[row - 1]
        
        
        var numOfFlowers = [0,0,0,0]
        
        for i in 0...3 {
            if model.grabBag.flowers[i] == tokenAdded.tokenData.flowerType {
                numOfFlowers[i] += 1
            } else if tokenAdded.tokenData.flowerType == "pond" {
                numOfFlowers[i] += 1
            }
        }
        
        
        var tokensArray = [tokenNode]()
        for location in locationArrayToCheck {
            for tokenToCheck in tokensInPlay {
                if location == tokenToCheck.tokenData.Location {
                    tokensArray.append(tokenToCheck)
                    break
                }
            }
        }
        for i in 0...3 {
            for tokenToCheck in tokensArray {
                if model.grabBag.flowers[i] == tokenToCheck.tokenData.flowerType {
                    numOfFlowers[i] += 1
                } else if tokenToCheck.tokenData.flowerType == "pond" {
                    numOfFlowers[i] += 1
                }
            }
        }
        let rawNumberOfFlowers = numOfFlowers.max()!
        
        let score = (rawNumberOfFlowers * (rawNumberOfFlowers + 1)) / 2
        
        return score
        
        
    }
    
    func getRowForToken(tokenNode: tokenNode, player: Int) -> Int {
        var row: Int!
        if player == 1 {
            for (index,locationArray) in playerRowsArray[0].enumerated() {
                for location in locationArray {
                    if tokenNode.tokenData.Location == location {
                        row = index + 1
                    }
                }
            }
        } else if player == 2 {
            for (index,locationArray) in playerRowsArray[1].enumerated() {
                for location in locationArray {
                    if tokenNode.tokenData.Location == location {
                        row = index + 1
                    }
                }
            }
        } else {
            row = tokenNode.tokenData.Location!.col
            
        }
        
        return row
    }
    
    func getAllAdjacentLocations(for tokenNode: tokenNode){
        
    }
    
    func muteMusic() {
           let mute = SKAction.changeVolume(to: 0.0, duration: 0.1)
           backgroundMusic.run(mute)
           isMutedSprite.isHidden = false
       }
       
       func unmuteMusic() {
           let unmute = SKAction.changeVolume(to: 1.0, duration: 0.0)
           backgroundMusic.run(unmute)
           isMutedSprite.isHidden = true
           
       }
    
    /*
    func endOfRoundScoring() {
        print("Started end of round scoring")
        
        //Stright down
        let player1RowsInt = [[[1,1,2],[1,2,3],[1,3,4],[1,4,5]],[[2,1,2],[2,2,3],[2,3,4],[2,4,5],[2,5,6]],[[3,1,1],[3,2,2],[3,3,3],[3,4,4],[3,5,5],[3,6,6]],[[4,1,1],[4,2,2],[4,3,3],[4,5,5],[4,6,6],[4,7,7]],[[5,1,1],[5,2,2],[5,3,3],[5,4,4],[5,5,5],[5,6,6]],[[6,1,2],[6,2,3],[6,3,4],[6,4,5],[6,5,6]],[[7,1,2],[7,2,3],[7,3,4],[7,4,5]]]
        
        
        //Top Left Down
        let player2RowsInt = [[[4,1,1],[3,1,1],[2,1,2],[1,1,2]],[[5,1,1],[4,2,2],[3,2,2],[2,2,3],[1,2,3]],[[6,1,2],[5,2,2],[4,3,3],[3,3,3],[2,3,4],[1,3,4]],[[7,1,2],[6,2,3],[5,3,3],[3,4,4],[2,4,5],[1,4,5]],[[7,2,3],[6,3,4],[5,4,4],[4,5,5],[3,5,5],[2,5,6]],[[7,3,4],[6,4,5],[5,5,5],[4,6,6],[3,6,6]],[[7,4,5],[6,5,6],[5,6,6],[4,7,7]]]
        
        //Top Right Down
        let player3RowsInt = [[[4,1,1],[5,1,1],[6,1,2],[7,1,2]],[[3,1,1],[4,2,2],[5,2,2],[6,2,3],[7,2,3]],[[2,1,2],[3,2,2],[4,3,3],[5,3,3],[6,3,4],[7,3,4]],[[1,1,2],[2,2,3],[3,3,3],[5,4,4],[6,4,5],[7,4,5]],[[1,2,3],[2,3,4],[3,4,4],[4,5,5],[5,5,5],[6,5,6]],[[1,3,4],[2,4,5],[3,5,5],[4,6,6],[5,6,6]],[[1,4,5],[2,5,6],[3,6,6,],[4,7,7]]]
        
        let player1Rows = makeLocationArray(arrayToConvert: player1RowsInt)
        let player2Rows = makeLocationArray(arrayToConvert: player2RowsInt)
        let player3Rows = makeLocationArray(arrayToConvert: player3RowsInt)
        let playerRowsArray = [player1Rows,player2Rows,player3Rows]
        
        
        
        var results = [0,0,0]
        
        for (index,playerRows) in playerRowsArray.enumerated() {
            for locationArray in playerRows {
                var numOfFlowers = [0,0,0,0]
                var tokensArray = [tokenNode]()
                for location in locationArray {
                    for tokenToCheck in tokensInPlay {
                        if location == tokenToCheck.tokenData.Location {
                            tokensArray.append(tokenToCheck)
                            break
                        }
                    }
                }
                for i in 0...3 {
                    for tokenToCheck in tokensArray {
                        if model.grabBag.flowers[i] == tokenToCheck.tokenData.flowerType {
                            numOfFlowers[i] += 1
                        } else if tokenToCheck.tokenData.flowerType == "pond" {
                            numOfFlowers[i] += 1
                        }
                    }
                }
                let rawNumberOfFlowers = numOfFlowers.max()!
                print("this is raw Flowers: \(rawNumberOfFlowers)")
                let score = (rawNumberOfFlowers * (rawNumberOfFlowers + 1)) / 2
                print("this is the score: \(score)")
                results[index] += score
                print("This is the results for \(index): \(results[index])")
                
            }
        }
        print("adding results to score")
        localPlayerOneScore += results[0]
        localPlayerTwoScore += results[1]
        localPlayerThreeScore += results[2]
    }
    */
    func makeLocationArray(arrayToConvert: [[[Int]]]) -> [[Location]]{
        var finishedArray = [[Location]]()
        for locationArray in arrayToConvert {
            var createdArrayOfLocations = [Location]()
            for location in locationArray {
                createdArrayOfLocations.append(Location(col: location[0], numInCol: location[1], posistioningNumInCol: location[2]))
            }
            finishedArray.append(createdArrayOfLocations)
        }
        print("made location array")
        return finishedArray
    }
    
    
    func checkForWinner() -> Int{
        let winner: Int
        let winnerScore = max(localPlayerOneScore,localPlayerTwoScore)
        if winnerScore == localPlayerOneScore {
            winner = 1
        } else if winnerScore == localPlayerTwoScore {
            winner = 2
        } else {
            winner = 4
        }
        return winner
    }
    
    
     
    
    
    
    
    /// Utility Funcs
    
    
    
    
    
    func getPositionOfTokenSpace(at location: Location) -> CGPoint? {
        for tokenSpaceToCheck in tokenSpacesInPlay {
            if tokenSpaceToCheck.Location.col == location.col && tokenSpaceToCheck.Location.numInCol == location.numInCol && tokenSpaceToCheck.Location.posistioningNumInCol == location.posistioningNumInCol {
                return tokenSpaceToCheck.position
            }
        }
        return nil
    }
    
    func addTouchableEffectSprite(in posistion: CGPoint, with size: CGSize) {
         let effectNode = SKSpriteNode(imageNamed: "GlowingGreenCircle")
            effectNode.size = size
            effectNode.position = posistion
            effectNode.zPosition = 2
            effectNode.xScale = 2.8
            effectNode.yScale = 2.8
            addChild(effectNode)
            effectNodesInPlay.append(effectNode)
    }
    
    func changeOrientation(to orientation: String){
        let fileName:String
        if orientation == "Landscape" {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if UIDevice.current.hasTopNotch {
                    self.size = CGSize(width: 2436, height: 1125 )
                    fileName = "singleplayerPhoneLand"
                } else {
                    self.size = CGSize(width: 1920, height: 1080 )
                    fileName = "singleplayerNoNotchLand"
                }
                
                
            } else {
                //Its an Ipad
                self.size = CGSize(width: 2048 , height: 1536 )
                fileName = "singleplayerPadLand"
            }
        } else if orientation == "Portrait" {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if UIDevice.current.hasTopNotch {
                   self.size = CGSize(width: 1125, height: 2436 )
                    fileName = "singleplayerPhonePortrait"
                } else {
                    self.size = CGSize(width: 1080, height: 1920 )
                    fileName = "singleplayerNoNotchPortrait"
                }
                
            } else {
                //Its an Ipad
                self.size = CGSize(width: 1536 , height: 2048 )
                fileName = "singleplayerPadPortrait"
            }
        } else {
            print("Invalid input for scene orientation change")
            return
        }
        
        let testModel = GameModel()
        if let sceneWithPositions = singleplayerGameScene(fileNamed: fileName, gameModel: testModel, difficulty: "easy") {
            
           touchBufferNode.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
            touchBufferNode.size = self.size
            
            //Hexagon
            centerHexagon.position = sceneWithPositions.centerHexagon.position
            //Token space
            for tokenSpace in tokenSpacesInPlay {
                tokenSpace.setPosition(in: centerHexagon)
            }
            
            //Player tokens
            
            for tokenNode in tokensInPlay {
                tokenNode.setPosition(in: centerHexagon)
            }
            
            
            for (index,playerToken) in playerTokenNodesInPlay.enumerated() {
                
                playerToken.position = sceneWithPositions.sksPlayerTokenNodes[index].position
                sksPlayerTokenNodes[index].position = sceneWithPositions.sksPlayerTokenNodes[index].position
                if effectNodesInPlay.count == 2 {
                    effectNodesInPlay[index].position = sceneWithPositions.sksPlayerTokenNodes[index].position
                }
                
               
            }
            
            
            //Score Bar, Labels, and Markers
            tilesBackground.zRotation = sceneWithPositions.tilesBackground.zRotation
            tilesBackground.position = sceneWithPositions.tilesBackground.position
            scoreBoard.position = sceneWithPositions.scoreBoard.position
            gameBoard.position = sceneWithPositions.gameBoard.position
            
            hamburgerButton.position = sceneWithPositions.hamburgerButton.position
            
            endGameContainer.position = sceneWithPositions.endGameContainer.position
            settingsContainer.position = sceneWithPositions.settingsContainer.position
            
            
            
        }
        
    }
    
    
    
    
    func makeNewPosistionForToken(at location: Location) -> CGPoint {
        let TokenSize = Int(centerHexagon.size.height/8)
        let differenceBetweenCol = centerHexagon.size.width/8
        let inColDifference = centerHexagon.size.height/8
        let top = centerHexagon.position.y + centerHexagon.size.height/2
        //let bottom = hexagon.position.y - hexagon.size.height/2
        //let left = hexagon.position.x - hexagon.size.width/2
        let right = centerHexagon.position.x + centerHexagon.size.width/2
        let pos: CGPoint
        if location.col % 2 == 0 {
            let x = Int(right) - (location.col * Int(differenceBetweenCol))
            let y = Int(top) - (location.posistioningNumInCol * Int(inColDifference))
            pos = CGPoint(x: x, y: y)
        } else {
            let x = Int(right) - (location.col * Int(differenceBetweenCol))
            let y = Int(top) - (location.posistioningNumInCol * Int(inColDifference)) - TokenSize/2
            pos = CGPoint(x: x, y: y)
        }
        return pos
    }
}

 
 
