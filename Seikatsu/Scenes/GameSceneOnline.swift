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

 class GameSceneOnline: SKScene {
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
    var localPlayerThreeScore = 0 {
        didSet {
            localPlayerThreeScoreLabel.text = "\(localPlayerThreeScore)"
        }
    }
    
    var rowScores = [[Int]]()
  
    

    var localPlayerOneScoreLabel: SKLabelNode!
    var localPlayerTwoScoreLabel: SKLabelNode!
    var localPlayerThreeScoreLabel: SKLabelNode!
    
    var scoreBoard: SKSpriteNode!
    var scoreBarContainerTemplate: SKSpriteNode!
    var scoreBars = [SKSpriteNode]()
    
    
    
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
    
    var checkmark: SKSpriteNode!
    var cross: SKSpriteNode!
    var pointsFromTilesLabel: SKLabelNode!
    var pointsFromRowsLabel: SKLabelNode!
    
    var playAgainButton: SKSpriteNode!
    var mainMenuButton: SKSpriteNode!
    var endGameContainer: SKSpriteNode!
    var finalScoreLabel: SKLabelNode!
    var winnerLabel: SKLabelNode!
    
    //Player One: Pink
    //Player Two: Blue
    //Player Three: Green
    
    convenience init?(fileNamed: String, gameModel: GameModel, player: Int){
      
        self.init(fileNamed: fileNamed)
        print("This is playerNum when initing \(player)")
        self.scaleMode = .aspectFill
        self.model = gameModel
        self.playerNum = player
       
        
        makeStartingPeices()
        loadGameModel()
    }
    
    
    
    
    
    
    ///Gameplay Functions
    
    
    
    
    
    
    
    @objc func loadGameModel(_ notification: Notification? = nil) {
        print("Function LoadGameModel started")
        if let notif = notification {
            guard let modelData = notif.object as? GameModel else {
                return
            }
            self.model = modelData
        }
      
        //Update All Tokens in Play
        //Loop over all tokens in play on local and compare to tokens in play on model
        //Look for differences and update local based on online model
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
        
        //Update All Player Hands
        //Just remove and replace all tokenNodes in the player hands
        for tokenNode in self.playerTokenNodesInPlay {
            tokenNode.removeFromParent()
        }
        self.playerTokenNodesInPlay.removeAll()
        for effectNode in self.effectNodesInPlay {
            effectNode.removeFromParent()
        }
        self.effectNodesInPlay.removeAll()
        
        if self.playerNum == 1 {
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
        } else if self.playerNum == 2 {
            for (index,token) in model.playerTwoHand.enumerated() {
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
        } else if self.playerNum == 3 {
            for (index,token) in model.playerThreeHand.enumerated() {
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
        }
        
        
        //Checks for TokenSpaces under current Tokens in play and removes them
        for tokenSpace in self.tokenSpacesInPlay {
            for token in self.tokensInPlay {
                if token.tokenData.Location == tokenSpace.Location {
                    removeTokenSpace(at: tokenSpace.Location)
                }
            }
        }
        
        // Updates scoring of all players
        //print("Player one score when recieved: \(model.playerOneScore)")
        //print("Player Two score when recieved: \(model.playerTwoScore)")
        //print("Player Three score when recieved: \(model.playerThreeScore)")
        updateScore(player: 1, setAt: model.playerOneScore)
        updateScore(player: 2, setAt: model.playerTwoScore)
        updateScore(player: 3, setAt: model.playerThreeScore)
        
        if let notif = notification {
            if notif.name == .roundEnd {
//                endOfRoundScoring()
                winnerLabel.fontName = "MyriadPro-Black"
                let winningPlayer = checkForWinner()
                if winningPlayer == playerNum {
                    winnerLabel.text = "You Win!"
                } else {
                    winnerLabel.text = "Player \(winningPlayer) Wins!"
                }
                
                finalScoreLabel.fontName = "MyriadPro-Black"
                if playerNum == 1 {
                    finalScoreLabel.text = "You Score is: \(localPlayerOneScore)"
                } else if playerNum == 2 {
                    finalScoreLabel.text = "You Score is: \(localPlayerTwoScore)"
                } else {
                    finalScoreLabel.text = "You Score is: \(localPlayerThreeScore)"
                }
                
                endGameContainer.isHidden = false
                gameplayPhase = 10

                return
            }
        }
        if model.playerTurn == playerNum {
            yourTurnIndicator.isHidden = false
        } else {
            yourTurnIndicator.isHidden = true
        }
        
        /*
        for (index,scoreToken) in scoreTokens.enumerated() {
            if model.playerTurn - 1 == index {
                addTouchableEffectSprite(in: scoreToken.position, with: scoreToken.size)
            }
        }
        */
       
        
         print("Function LoadGameModel Ended")
    }
    
    
    func makeStartingPeices() {
        print("Function makeStartingPeices started")
        
        self.scoreBoard = self.childNode(withName: "scoreBoard") as? SKSpriteNode
        self.localPlayerOneScoreLabel = scoreBoard.childNode(withName: "localPlayerOneScoreLabel") as? SKLabelNode
        self.localPlayerTwoScoreLabel = scoreBoard.childNode(withName: "localPlayerTwoScoreLabel") as? SKLabelNode
        self.localPlayerThreeScoreLabel = scoreBoard.childNode(withName: "localPlayerThreeScoreLabel") as? SKLabelNode
        self.scoreBarContainerTemplate = scoreBoard.childNode(withName: "scoreBarContainerTemplate") as? SKSpriteNode
        for num in 1...3 {
            let scoreBarString = "scoreBar" + String(num)
            if let scoreBar = scoreBoard.childNode(withName: scoreBarString) as? SKSpriteNode {
                scoreBars.append(scoreBar)
            }
        }
        
        self.yourTurnIndicator = self.childNode(withName: "yourTurnIndicator") as? SKSpriteNode
        self.hamburgerButton = self.childNode(withName: "hamburgerButton") as? SKSpriteNode
        
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
        
        self.winnerLabel = self.childNode(withName: "winnerLabel") as? SKLabelNode
        
        self.finalScoreLabel = self.childNode(withName: "finalScoreLabel") as? SKLabelNode
        
        
        
        
        
        
        
        print("Function MakeStartingPieces Ended")
    }
    
    override func sceneDidLoad() {
         print("Function SceneDidLoad started")
        NotificationCenter.default.addObserver(self, selector: #selector(loadGameModel(_:)), name: .turnStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadGameModel(_:)), name: .roundEnd, object: nil)
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
       
        
        if self.playerNum == 1 {
            for (index,token) in model.playerOneHand.enumerated() {
                print("index is \(index)")
                let nodeOfToken = tokenNode(token: token)
                let posistionOfNode = sksPlayerTokenNodes[index].position
                nodeOfToken.sprite!.size = sksPlayerTokenNodes[index].size
                nodeOfToken.placeTokenNode(in: posistionOfNode, on: self)
                playerTokenNodesInPlay.append(nodeOfToken)
            }
        } else if self.playerNum == 2 {
            for (index,token) in model.playerTwoHand.enumerated() {
                let nodeOfToken = tokenNode(token: token)
                let posistionOfNode = sksPlayerTokenNodes[index].position
                nodeOfToken.sprite!.size = sksPlayerTokenNodes[index].size
                nodeOfToken.placeTokenNode(in: posistionOfNode, on: self)
                playerTokenNodesInPlay.append(nodeOfToken)
            }
        } else if self.playerNum == 3 {
            for (index,token) in model.playerThreeHand.enumerated() {
                let nodeOfToken = tokenNode(token: token)
                let posistionOfNode = sksPlayerTokenNodes[index].position
                nodeOfToken.sprite!.size = sksPlayerTokenNodes[index].size
                nodeOfToken.placeTokenNode(in: posistionOfNode, on: self)
                playerTokenNodesInPlay.append(nodeOfToken)
            }
        }
        
        for _ in 0...2 {
            let arrayOfScores = [0,0,0,0,0,0,0]
            rowScores.append(arrayOfScores)
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
//                    quitButton.texture = SKTexture(imageNamed: "quitButtonPressed")
                } else if node.name == "howToPlayButton" {
                    howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButtonPressed")
                } else if node.name == "resumeButton" {
                    resumeButton.texture = SKTexture(imageNamed: "resumeButtonPressed")
                } else if node.name == "playAgainButton" {
                    playAgainButton.texture = SKTexture(imageNamed: "playAgainButtonPressed")
                } else if node.name == "mainMenuButton" {
//                    mainMenuButton.texture = SKTexture(imageNamed: "mainMenuButtonPressed")
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                
                
                
                if menuContainer.isHidden == false {
                    if node.name == "settingsButton" {
                        print("Settings button Pressed")
                        settingsButton.texture = SKTexture(imageNamed: "settingsButton")
                        menuContainer.isHidden = true
                        return
                    } else if node.name == "quitButton" {
                        //quitButton.texture = SKTexture(imageNamed: "quitButton")
                        print("Quit button Pressed")
                        SocketIOHelper.helper.quitMatch()
                        backToMainMenuScene()
                        return
                    } else if node.name == "howToPlayButton" {
                        print("HowToPlay button Pressed")
                        howToPlayButton.texture = SKTexture(imageNamed: "howToPlayButton")
                         menuContainer.isHidden = true
                        return
                    } else if node.name == "resumeButton" {
                        print("Resume button Pressed")
                        resumeButton.texture = SKTexture(imageNamed: "resumeButton")
                        menuContainer.isHidden = true
                        return
                    }
                }
                
                guard menuContainer.isHidden == true else {
                    return
                }
                
                if node.name == "hamburgerButton" {
                    hamburgerButton.texture = SKTexture(imageNamed: "hamburgerButton")
                    bringUpMenu()
                    return
                }
                
                guard model.playerTurn == playerNum else {
                    print("Not your turn")
                    print("Turn num is: \(model.playerTurn)")
                    print("You are num: \(String(describing: playerNum))")
                    return
                }
                
                if gameplayPhase == 0 {
                    if node.name == "tokenNode" {
                        tokenNodeTouched(node: node, phase: 0)
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
                        NotificationCenter.default.post(name: .playAgain, object: nil)
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
            addScoreFromPlacing(tokenNodeToCheck: nodeToPlace)
            let playerTurn = model.playerTurn
            
            var plusPointsFromRow = getScoreForRowWithTokenAdded(row: tokenSpaceNode.Location.col, player: playerTurn, tokenAdded: nodeToPlace) - rowScores[playerTurn - 1][tokenSpaceNode.Location.col - 1]
            if plusPointsFromRow < 0 {
                plusPointsFromRow = 0
            }
            updateScore(player: playerTurn, amount: plusPointsFromRow)
            rowScores[playerTurn - 1][tokenSpaceNode.Location.col - 1] += plusPointsFromRow
            
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
                gameplayPhase = 2
                guard let tokenSpaceNode = node as? TokenSpace else {
                    return
                }
                nodeToPlace.tokenData.Location = tokenSpaceNode.Location
                selectedTokenOldPosistion = selectedToken?.position
                phaseThreeGraphics(nodeToPlace: nodeToPlace, tokenSpace: tokenSpaceNode)
                selectedTokenSpace = tokenSpaceNode
                
                
                /*
                selectedTokenOldPosistion = selectedToken?.position
                nodeToPlace.position = node.position
                let tokenSpaceNode = node as! TokenSpace
                
                
                nodeToPlace.tokenData.Location = tokenSpaceNode.Location
                addScoreFromPlacing(tokenNodeToCheck: nodeToPlace)
                tokensInPlay.append(nodeToPlace)
                model.TokensInPlay.append(nodeToPlace.tokenData)
                nodeToPlace.tokenData.player = nil
                nodeToPlace.xScale = 1.0
                nodeToPlace.yScale = 1.0
                nodeToPlace.zPosition = 20
                nodeToPlace.sprite?.size = CGSize(width: centerHexagon.size.height/8, height: centerHexagon.size.height/8)
                removeTokenSpace(at: tokenSpaceNode.Location)
                nextTurn()
                 */
            } else {
                print("Error: Selected Token Not Found")
            }
        }
    }
    
    //executed when Player turn has ended, after placing new TokenNode
    func nextTurn() {
        model.turnNum += 1
        let oldPosition = selectedTokenOldPosistion
        if playerNum == 1 {
            for (index,token) in model.playerOneHand.enumerated() {
                if token == selectedToken?.tokenData {
                    model.playerOneHand.remove(at: index)
                }
            }
        } else if playerNum == 2 {
            for (index,token) in model.playerTwoHand.enumerated() {
                if token == selectedToken?.tokenData {
                    model.playerTwoHand.remove(at: index)
                }
            }
        } else if playerNum == 3 {
            for (index,token) in model.playerThreeHand.enumerated() {
                if token == selectedToken?.tokenData {
                    model.playerThreeHand.remove(at: index)
                }
            }
        }
        for (index, token) in self.playerTokenNodesInPlay.enumerated() {
            if selectedToken?.tokenData == token.tokenData {
                self.playerTokenNodesInPlay.remove(at: index)
            }
        }
        
        selectedToken = nil
        model.playerTurn = playerNum + 1
        if model.playerTurn == 4 {
            model.playerTurn = 1
        }
        drawNewToken(for: self.playerNum, at: oldPosition!)
        gameplayPhase = 0
        
        if model.turnNum >= 33 {
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
        SocketIOHelper.helper.endTurn(model: self.model)
    }
        
    func tokenNodeTouched(node: SKNode, phase: Int) {
        if phase == 0 {
            let tokenNode = node as? tokenNode
            if tokenNode?.tokenData.player == model.playerTurn {
                selectedToken = tokenNode
                gameplayPhase = 1
                tokenNode?.xScale = 1.15
                tokenNode?.yScale = 1.15
                tokenNode?.zPosition = 21
            }
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
        model.playerTurn = 4
        SocketIOHelper.helper.endRound(model: self.model)
    }
    
    func bringUpMenu() {
        menuContainer.isHidden = false
    }
    
    func backToMainMenuScene() {
        if let fileName = getFileName() {
            if let scene = MenuScene(fileNamed: fileName) {
                scene.scaleMode = .aspectFill
                
                
                self.view?.presentScene(scene)
                
                
                self.view?.ignoresSiblingOrder = true
                self.view?.showsFPS = true
                self.view?.showsNodeCount = true
                
                
            } else {
                print("Couldn't create Menu Scene")
            }
            
        } else {
            print("Couldn't get File Name for Menu Scene")
        }
        return
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
    func drawNewToken(for player: Int, at position: CGPoint) {
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
        
        
        checkmark.position = CGPoint(x: topOfNodeToPlace.x + (nodeToPlace.sprite?.size.width)!/2 + 15, y: topOfNodeToPlace.y)
        cross.position = CGPoint(x: checkmark.position.x + 75, y: checkmark.position.y)
        checkmark.isHidden = false
        cross.isHidden = false
        
        pointsFromTilesLabel.position = CGPoint(x: nodeToPlace.position.x - (nodeToPlace.sprite?.size.width)!/2 - 25, y: nodeToPlace.position.y)
        pointsFromTilesLabel.text = "+\(getScoreFromPlacing(tokenNodeToCheck: nodeToPlace))"
        pointsFromTilesLabel.isHidden = false
        
        pointsFromRowsLabel.position = CGPoint(x: pointsFromTilesLabel.position.x, y: pointsFromTilesLabel.position.y - 50)
        
        let playerTurn = model.playerTurn
        var plusPointsFromRow = getScoreForRowWithTokenAdded(row: tokenSpace.Location.col, player: playerTurn, tokenAdded: nodeToPlace) - rowScores[playerTurn - 1][tokenSpace.Location.col - 1]
        if plusPointsFromRow < 0 {
            plusPointsFromRow = 0
        }
            
        pointsFromRowsLabel.text = "+\(getScoreFromPlacing(tokenNodeToCheck: nodeToPlace))"
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
    func getScoreFromPlacing(tokenNodeToCheck: tokenNode) -> Int {
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
    
    
    
    func addScoreFromPlacing(tokenNodeToCheck: tokenNode) {
        let amountToAdd = getScoreFromPlacing(tokenNodeToCheck: tokenNodeToCheck)
        
        // add the score here
        if self.playerNum == 1 {
            updateScore(player: 1, amount: amountToAdd)
        } else if self.playerNum == 2 {
            updateScore(player: 2, amount: amountToAdd)
        } else if self.playerNum == 3 {
            updateScore(player: 3, amount: amountToAdd)
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
            } else if player == 3 {
                model.playerThreeScore += amount
                localPlayerThreeScore += amount
                moveScoreBars(player: player, score: model.playerThreeScore)
            } else {
                print("error Updating score, player not found")
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
            } else if player == 3 {
                model.playerThreeScore = setAt
                localPlayerThreeScore = setAt
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
    
    
    func getScoreForRowWithTokenAdded(row: Int, player: Int, tokenAdded: tokenNode) -> Int {
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
        
        let playerArrayToCheck = playerRowsArray[player - 1]
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
        let winnerScore = max(max(localPlayerOneScore,localPlayerTwoScore), localPlayerThreeScore)
        if winnerScore == localPlayerOneScore {
            winner = 1
        } else if winnerScore == localPlayerTwoScore {
            winner = 2
        } else if winnerScore == localPlayerThreeScore {
            winner = 3
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
    
    
    func switchToLandscape() {
        /*
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.size = CGSize(width: 2436, height: 1125)
            //Things to change: Hexagon
            centerHexagon.position = CGPoint(x: 568 ,y: 562.5)
            //Player tokens
            for (index,playerToken) in playerTokenNodesInPlay.enumerated() {
                let x: Int
                if index == 0 {
                    x = 1334
                } else {
                    x = 1800
                }
                playerToken.position = CGPoint(x: x, y: 208)
                sksPlayerTokenNodes[index].position = CGPoint(x: x, y: 208)
            }
            
            //Score Bar, Labels, and Markers
            //scoreBar.position = CGPoint(x: 1800, y: 888)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 1500, y: 808)
            localPlayerTwoScoreLabel.position = CGPoint(x: 1800, y: 808)
            localPlayerThreeScoreLabel.position = CGPoint(x: 2100, y: 808)
            
            for (index,scoreToken) in scoreBars.enumerated() {
                let x: Int
                if index == 0 {
                    x = 1500
                } else if index == 1 {
                    x = 1800
                } else {
                    x = 2100
                }
                scoreToken.position = CGPoint(x: x, y: 888)
            }
            
            //background
            ///Dont have one yet
            
            //Nodes Inside Hexagon, this is haaaaaaaard. Fine. Ill do it.
            for tokenSpace in tokenSpacesInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenSpace.Location)
                tokenSpace.position = newPosition
            }
            for tokenNode in tokensInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenNode.tokenData.Location!)
                tokenNode.position = newPosition
            }
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            //Ipad landscape setup
            self.size = CGSize(width: 2048, height: 1536)
            //Things to change: Hexagon
            centerHexagon.position = CGPoint(x: 650 ,y: 768)
            //Player tokens
            for (index,playerToken) in playerTokenNodesInPlay.enumerated() {
                let x: Int
                if index == 0 {
                    x = 1344
                } else {
                    x = 1800
                }
                playerToken.position = CGPoint(x: x, y: 208)
                sksPlayerTokenNodes[index].position = CGPoint(x: x, y: 208)
            }
            
            //Score Bar, Labels, and Markers
            //scoreBar.position = CGPoint(x: 1525, y: 1300)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 1220, y: 1220)
            localPlayerTwoScoreLabel.position = CGPoint(x: 1520, y: 1220)
            localPlayerThreeScoreLabel.position = CGPoint(x: 1820, y: 1220)
            
            for (index,scoreToken) in scoreBars.enumerated() {
                let x: Int
                if index == 0 {
                    x = 1220
                } else if index == 1 {
                    x = 1520
                } else {
                    x = 1820
                }
                scoreToken.position = CGPoint(x: x, y: 1300)
            }
            
            //background
            ///Dont have one yet
            
            
            //Nodes Inside Hexagon, this is haaaaaaaard. Fine. Ill do it.
            for tokenSpace in tokenSpacesInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenSpace.Location)
                tokenSpace.position = newPosition
            }
            for tokenNode in tokensInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenNode.tokenData.Location!)
                tokenNode.position = newPosition
            }
        }
        */
    }
    
    func switchToPortrait() {
        /*
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.size = CGSize(width: 1125, height: 2436)
            
            //Things to change: Hexagon
            centerHexagon.position = CGPoint(x: 562.5, y: 1568)
            //Player tokens
            for (index,playerToken) in playerTokenNodesInPlay.enumerated() {
                let x: Double
                if index == 0 {
                    x = 320
                } else {
                    x = 827.5
                }
                playerToken.position = CGPoint(x: x, y: 772.5)
                sksPlayerTokenNodes[index].position = CGPoint(x: x, y: 772.5)
            }
            //Score Bar, Labels, and Markers
            //scoreBar.position = CGPoint(x: 575, y: 325)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 275, y: 245)
            localPlayerTwoScoreLabel.position = CGPoint(x: 575, y: 245)
            localPlayerThreeScoreLabel.position = CGPoint(x: 875, y: 245)
            
            for (index,scoreToken) in scoreBars.enumerated() {
                let x: Int
                if index == 0 {
                    x = 275
                } else if index == 1 {
                    x = 575
                } else {
                    x = 875
                }
                scoreToken.position = CGPoint(x: x, y: 325)
            }
            
            //background
            ///Dont have one yet
            
            
            //Nodes Inside Hexagon, this is haaaaaaaard. Fine. Ill do it.
            for tokenSpace in tokenSpacesInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenSpace.Location)
                tokenSpace.position = newPosition
            }
            for tokenNode in tokensInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenNode.tokenData.Location!)
                tokenNode.position = newPosition
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            self.size = CGSize(width: 1536, height: 2048)
            
            //Things to change: Hexagon
            centerHexagon.position = CGPoint(x: 768, y: 1334)
            //Player tokens
            for (index,playerToken) in playerTokenNodesInPlay.enumerated() {
                let x: Double
                if index == 0 {
                    x = 318
                } else {
                    x = 1218
                }
                playerToken.position = CGPoint(x: x, y: 520)
                 sksPlayerTokenNodes[index].position = CGPoint(x: x, y: 520)
            }
            //Score Bar, Labels, and Markers
            //scoreBar.position = CGPoint(x: 768, y: 120)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 468, y: 40)
            localPlayerTwoScoreLabel.position = CGPoint(x: 768, y: 40)
            localPlayerThreeScoreLabel.position = CGPoint(x: 1068, y: 40)
            
            for (index,scoreToken) in scoreBars.enumerated() {
                let x: Int
                if index == 0 {
                    x = 468
                } else if index == 1 {
                    x = 768
                } else {
                    x = 1068
                }
                scoreToken.position = CGPoint(x: x, y: 120)
            }
            
            //background
            
            
            ///Dont have one yet
            
            
            //Nodes Inside Hexagon, this is haaaaaaaard. Fine. Ill do it.
            for tokenSpace in tokenSpacesInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenSpace.Location)
                tokenSpace.position = newPosition
            }
            for tokenNode in tokensInPlay {
                let newPosition = makeNewPosistionForToken(at: tokenNode.tokenData.Location!)
                tokenNode.position = newPosition
            }
        }
 */
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

 
 
