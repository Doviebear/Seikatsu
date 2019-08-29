//
//  GameSceneOnline.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 8/7/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

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
  
    

    var localPlayerOneScoreLabel: SKLabelNode!
    var localPlayerTwoScoreLabel: SKLabelNode!
    var localPlayerThreeScoreLabel: SKLabelNode!
    
    
    var scoreBar: SKSpriteNode!
    var scoreTokens = [SKSpriteNode]()
    
    
    
    var centerHexagon: SKSpriteNode!
    var playerNum: Int!
    var sksPlayerTokenNodes = [SKSpriteNode]()
    var playerColorSprites = [SKSpriteNode]()
    
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
                endOfRoundScoring()
                if let winnerLabel = self.childNode(withName: "winnerLabel") as? SKLabelNode {
                    winnerLabel.text = "Player \(checkForWinner()) Wins!"
                    winnerLabel.isHidden = false
                }
                return
            }
        }
        
        for (index,scoreToken) in scoreTokens.enumerated() {
            if model.playerTurn - 1 == index {
                addTouchableEffectSprite(in: scoreToken.position, with: scoreToken.size)
            }
        }
        
       
        
         print("Function LoadGameModel Ended")
    }
    
    
    func makeStartingPeices() {
        print("Function makeStartingPeices started")
        
        self.localPlayerOneScoreLabel = self.childNode(withName: "localPlayerOneScoreLabel") as? SKLabelNode
        self.localPlayerTwoScoreLabel = self.childNode(withName: "localPlayerTwoScoreLabel") as? SKLabelNode
        self.localPlayerThreeScoreLabel = self.childNode(withName: "localPlayerThreeScoreLabel") as? SKLabelNode
        self.scoreBar = self.childNode(withName: "scoreBar") as? SKSpriteNode
        for num in 1...3 {
            let scoreTokenString = "scoreToken" + String(num)
            if let scoreToken = self.childNode(withName: scoreTokenString) as? SKSpriteNode {
                scoreTokens.append(scoreToken)
            }
        }
        
        for num in 1...2 {
            let playerColorSpriteString = "playerColorSprite" + String(num)
            if let playerColorSprite = self.childNode(withName: playerColorSpriteString) as? SKSpriteNode {
                if self.playerNum == 1 {
                    playerColorSprite.texture = SKTexture(imageNamed: "PinkRectangle")
                } else if self.playerNum == 2 {
                    playerColorSprite.texture = SKTexture(imageNamed: "BlueRectangle")
                } else if self.playerNum == 3 {
                    playerColorSprite.texture = SKTexture(imageNamed: "GreenRectangle")
                } else {
                    print("Couldn't change player Color Sprites, couldn't get player Num")
                }
                playerColorSprites.append(playerColorSprite)
            }
        }
        
        
        
        
        
        
        
        
        /*
         let token1 = model.grabBag.drawToken(canBeKoiPond: false)
         let nodeOfToken1 = tokenNode(token: token1)
         let Location1 = Location(col: 3, numInCol: 3, posistioningNumInCol: 3)
         nodeOfToken1.tokenData.Location = Location1
         nodeOfToken1.placeTokenNode(in: getPositionOfTokenSpace(at: Location1) ?? CGPoint(x: 0, y: 0), on: self)
         removeTokenSpace(at: Location1)
         tokensInPlay.append(nodeOfToken1)
         model.TokensInPlay.append(nodeOfToken1.tokenData)
         
         let token2 = model.grabBag.drawToken(canBeKoiPond: false)
         let nodeOfToken2 = tokenNode(token: token2)
         let Location2 = Location(col: 5, numInCol: 3, posistioningNumInCol: 3)
         nodeOfToken2.tokenData.Location = Location2
         nodeOfToken2.placeTokenNode(in: getPositionOfTokenSpace(at: Location2) ?? CGPoint(x: 0, y: 0), on: self)
         removeTokenSpace(at: Location2)
         tokensInPlay.append(nodeOfToken2)
         model.TokensInPlay.append(nodeOfToken2.tokenData)
         
         let token3 = model.grabBag.drawToken(canBeKoiPond: false)
         let nodeOfToken3 = tokenNode(token: token3)
         let Location3 = Location(col: 4, numInCol: 5, posistioningNumInCol: 5)
         nodeOfToken3.tokenData.Location = Location3
         nodeOfToken3.placeTokenNode(in: getPositionOfTokenSpace(at: Location3) ?? CGPoint(x: 0, y: 0), on: self)
         removeTokenSpace(at: Location3)
         tokensInPlay.append(nodeOfToken3)
         model.TokensInPlay.append(nodeOfToken3.tokenData)
         
         
         localPlayerOneScoreLabel = SKLabelNode(text: "P1 Score is: \(localPlayerOneScore)")
         localPlayerOneScoreLabel.position = CGPoint(x: 400 , y: Int(JKGame.rect.minY) + 200)
         localPlayerOneScoreLabel.fontName = "RussoOne-Regular"
         localPlayerOneScoreLabel.zPosition = 7
         addChild(localPlayerOneScoreLabel)
         
         
         localPlayerTwoScoreLabel = SKLabelNode(text: "P2 Score is: \(localPlayerTwoScore)")
         localPlayerTwoScoreLabel.position = CGPoint(x: 400, y: Int(JKGame.rect.maxY) - 150)
         localPlayerTwoScoreLabel.fontName = "RussoOne-Regular"
         localPlayerTwoScoreLabel.zPosition = 7
         addChild(localPlayerTwoScoreLabel)
         
         localPlayerThreeScoreLabel = SKLabelNode(text: "P3 Score is: \(localPlayerThreeScore)")
         localPlayerThreeScoreLabel.position = CGPoint(x: Int(JKGame.rect.maxX) - 400, y: Int(JKGame.rect.maxY) - 150)
         localPlayerThreeScoreLabel.fontName = "RussoOne-Regular"
         localPlayerThreeScoreLabel.zPosition = 7
         addChild(localPlayerThreeScoreLabel)
         
         centerCircle = SKShapeNode(circleOfRadius: 425)
         centerCircle.fillColor = UIColor(rgb: 0xffd480) //Tan
         centerCircle.lineWidth = 0
         centerCircle.zPosition = 5
         centerCircle.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY)
         addChild(centerCircle)
         
         player1Box = SKShapeNode(rectOf: CGSize(width: JKGame.rect.width, height: JKGame.rect.height/2))
         player1Box.fillColor = UIColor(rgb: 0xff66cc) //Pink
         player1Box.lineWidth = 0
         player1Box.zPosition = 3
         player1Box.position = CGPoint(x: JKGame.rect.midX, y: JKGame.rect.midY/2)
         addChild(player1Box)
         
         player2Box = SKShapeNode(rectOf: CGSize(width: JKGame.rect.width/2, height: JKGame.rect.height))
         player2Box.fillColor = UIColor(rgb: 0x33ccff) //light blue
         player2Box.lineWidth = 0
         player2Box.zPosition = 2
         player2Box.position = CGPoint(x: JKGame.rect.midX/2, y: JKGame.rect.midY)
         addChild(player2Box)
         
         player3Box = SKShapeNode(rectOf: CGSize(width: JKGame.rect.width/2, height: JKGame.rect.height))
         player3Box.fillColor = UIColor(rgb: 0x009900) //Green
         player3Box.lineWidth = 0
         player3Box.zPosition = 2
         player3Box.position = CGPoint(x: JKGame.rect.midX/2 * 3, y: JKGame.rect.midY)
         addChild(player3Box)
         
         turnIndicator = SKShapeNode(circleOfRadius: 12.5)
         turnIndicator.fillColor = UIColor(rgb: 0xff5050) //red
         turnIndicator.zPosition = 8
         turnIndicator.lineWidth = 0
         turnIndicator.position = CGPoint(x: 400, y: Int(JKGame.rect.minY) + 200 - 25 )
         addChild(turnIndicator)
         */
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
        
       
        
         print("Function SceneDidLoad Ended")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard model.playerTurn == playerNum else {
            print("Not your turn")
            print("Turn num is: \(model.playerTurn)")
            print("You are num: \(String(describing: playerNum))")
            return
        }
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
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
                }
            }
        }
    }
    
    //executed when a TokenNode has already been selected and a player taps on a tokenSpace to play the token
    func tokenSpaceTouched(node: SKNode, phase: Int){
        if phase == 1 {
            if let nodeToPlace = selectedToken {
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
    
    func addScoreFromPlacing(tokenNodeToCheck: tokenNode) {
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
        
        // add the score here
        if self.playerNum == 1 {
            updateScore(player: 1, amount: count)
        } else if self.playerNum == 2 {
            updateScore(player: 2, amount: count)
        } else if self.playerNum == 3 {
            updateScore(player: 3, amount: count)
        } else {
            print("Error adding score, Player not found")
        }
        
    }
    
    
    func updateScore(player: Int, amount: Int? = nil, setAt: Int? = nil) {
        if let amount = amount {
            if player == 1 {
                model.playerOneScore += amount
                localPlayerOneScore += amount
            } else if player == 2 {
                model.playerTwoScore += amount
                localPlayerTwoScore += amount
            } else if player == 3 {
                model.playerThreeScore += amount
                localPlayerThreeScore += amount
            } else {
                print("error Updating score, player not found")
            }
            return
        } else if let setAt = setAt {
            if player == 1 {
                model.playerOneScore = setAt
                localPlayerOneScore = setAt
            } else if player == 2 {
                model.playerTwoScore = setAt
                localPlayerTwoScore = setAt
            } else if player == 3 {
                model.playerThreeScore = setAt
                localPlayerThreeScore = setAt
            } else {
                print("error Updating score, player not found")
            }
            return
        } else {
            print("Errot updating score, both values are nil")
        }
    }
    
    
    func moveScoreTokens(player: Int, score: Int) {
      
        
        
        
        
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
            scoreBar.position = CGPoint(x: 1800, y: 888)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 1500, y: 808)
            localPlayerTwoScoreLabel.position = CGPoint(x: 1800, y: 808)
            localPlayerThreeScoreLabel.position = CGPoint(x: 2100, y: 808)
            
            for (index,scoreToken) in scoreTokens.enumerated() {
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
            scoreBar.position = CGPoint(x: 1525, y: 1300)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 1220, y: 1220)
            localPlayerTwoScoreLabel.position = CGPoint(x: 1520, y: 1220)
            localPlayerThreeScoreLabel.position = CGPoint(x: 1820, y: 1220)
            
            for (index,scoreToken) in scoreTokens.enumerated() {
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
    }
    
    func switchToPortrait() {
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
            scoreBar.position = CGPoint(x: 575, y: 325)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 275, y: 245)
            localPlayerTwoScoreLabel.position = CGPoint(x: 575, y: 245)
            localPlayerThreeScoreLabel.position = CGPoint(x: 875, y: 245)
            
            for (index,scoreToken) in scoreTokens.enumerated() {
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
            scoreBar.position = CGPoint(x: 768, y: 120)
            
            localPlayerOneScoreLabel.position = CGPoint(x: 468, y: 40)
            localPlayerTwoScoreLabel.position = CGPoint(x: 768, y: 40)
            localPlayerThreeScoreLabel.position = CGPoint(x: 1068, y: 40)
            
            for (index,scoreToken) in scoreTokens.enumerated() {
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

 
 
