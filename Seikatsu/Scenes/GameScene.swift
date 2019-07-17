//
//  GameScene.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var model: GameModel
    var tokensInPlay = [tokenNode]()
    var tokenSpacesInPlay = [TokenSpace]()
    // 0 is new turn start, 1 is picked from hand
    var gameplayPhase = 0
    var selectedToken: tokenNode?
    var selectedTokenOldPosistion: CGPoint?
    var localPlayerOneScore = 0 {
        didSet {
            localPlayerOneScoreLabel.text = "P1 Score is: \(localPlayerOneScore)"
        }
    }
    var localPlayerTwoScore = 0 {
        didSet {
            localPlayerTwoScoreLabel.text = "P2 Score is: \(localPlayerTwoScore)"
        }
    }
    var localPlayerThreeScore = 0 {
        didSet {
            localPlayerThreeScoreLabel.text = "P3 Score is: \(localPlayerThreeScore)"
        }
    }
    
    var localPlayerOneScoreLabel: SKLabelNode!
    var localPlayerTwoScoreLabel: SKLabelNode!
    var localPlayerThreeScoreLabel: SKLabelNode!
    
    
    
    
    
    override init(){
        self.model = GameModel()
        super.init(size: JKGame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        for i in 1...2 {
            for k in 1...4 {
                var col = 1
                if i == 2 {
                     col = 7
                }
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k + 1), textureName: "circleNode")
                tokenSpace.drawNode(on: self)
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
                tokenSpace.drawNode(on: self)
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
                tokenSpace.drawNode(on: self)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        for k in 1...7 {
            let col = 4
            if k != 4 {
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k), textureName: "circleNode")
                tokenSpace.drawNode(on: self)
                tokenSpacesInPlay.append(tokenSpace)
            }
        }
        
        for (index,token) in model.playerOneHand.enumerated() {
            let nodeOfToken = tokenNode(token: token)
            nodeOfToken.placeTokenNode(in: CGPoint(x: 100 + (100 * index) ,y: Int(JKGame.rect.minY) + 200), on: self)
        }
        for (index,token) in model.playerTwoHand.enumerated() {
            let nodeOfToken = tokenNode(token: token)
            nodeOfToken.placeTokenNode(in: CGPoint(x: 100 + (100 * index) ,y: Int(JKGame.rect.maxY) - 150), on: self)
        }
        for (index,token) in model.playerThreeHand.enumerated() {
            let nodeOfToken = tokenNode(token: token)
            nodeOfToken.placeTokenNode(in: CGPoint(x: Int(JKGame.rect.maxX) - 100 - (100 * index),y: Int(JKGame.rect.midY)), on: self)
        }
        
        
        makeStartingPeices()
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                if gameplayPhase == 0 {
                    if node.name == "tokenNode" {
                        tokenNodeTouched(node: node)
                    }
                } else if gameplayPhase == 1 {
                    if node.name == "tokenSpace" {
                        tokenSpaceTouched(node: node)
                    }
                }
            }
        }
    }
    
    func tokenSpaceTouched(node: SKNode){
        if let nodeToPlace = selectedToken {
            selectedTokenOldPosistion = selectedToken?.position
            nodeToPlace.position = node.position
            let tokenSpaceNode = node as! TokenSpace
            nodeToPlace.tokenData.Location = tokenSpaceNode.Location
            addScoreFromPlacing(tokenNodeToCheck: nodeToPlace)
            tokensInPlay.append(nodeToPlace)
            nodeToPlace.tokenData.player = nil
            node.removeFromParent()
            nextTurn()
        } else {
            print("Error: Selected Token Not Found")
        }
    }
    
    func nextTurn() {
        let oldPosition = selectedTokenOldPosistion
        if model.playerTurn == 1 {
            for (index,token) in model.playerOneHand.enumerated() {
                if token === selectedToken?.tokenData {
                    model.playerOneHand.remove(at: index)
                    selectedToken = nil
                }
            }
            model.playerTurn = 2
            drawNewToken(for: 1, at: oldPosition!)
        } else if model.playerTurn == 2 {
            for (index,token) in model.playerTwoHand.enumerated() {
                if token === selectedToken?.tokenData {
                    model.playerTwoHand.remove(at: index)
                    selectedToken = nil
                }
            }
            model.playerTurn = 3
            drawNewToken(for: 2, at: oldPosition!)
        } else if model.playerTurn == 3 {
            for (index,token) in model.playerThreeHand.enumerated() {
                if token === selectedToken?.tokenData {
                    model.playerThreeHand.remove(at: index)
                    selectedToken = nil
                }
            }
            model.playerTurn = 1
            drawNewToken(for: 3, at: oldPosition!)
        }
        gameplayPhase = 0
    }
    
    func drawNewToken(for player: Int, at position: CGPoint) {
        if model.grabBag.tokens.count <= 0 {
            return
        }
        let token = model.grabBag.drawToken()
        let nodeOfToken = tokenNode(token: token)
        nodeOfToken.placeTokenNode(in: position, on: self)
        
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
    
    func tokenNodeTouched(node: SKNode) {
        let tokenNode = node as? tokenNode
        if tokenNode?.tokenData.player == model.playerTurn {
            selectedToken = tokenNode
            gameplayPhase = 1
        }
    }
   
    
    /// Scoring
    
    func addScoreFromPlacing(tokenNodeToCheck: tokenNode) {
        var adjacentTokens = [tokenNode]()
        for token in tokensInPlay {
            if tokenNodeToCheck.isAdjacent(tokenNode2: token) {
                adjacentTokens.append(token)
            }
        }
        var count = 0
        for adjacentToken in adjacentTokens {
            if tokenNodeToCheck.tokenData.birdType == adjacentToken.tokenData.birdType && tokenNodeToCheck.tokenData.birdType != "pond" {
                if count == 0 {
                    count = 1
                }
                count += 1
            }
        }
        
        // add the score here
        if tokenNodeToCheck.tokenData.player == 1 {
            updateScore(player: 1, amount: count)
        } else if tokenNodeToCheck.tokenData.player == 2 {
            updateScore(player: 2, amount: count)
        } else if tokenNodeToCheck.tokenData.player == 3 {
            updateScore(player: 3, amount: count)
        } else {
            print("Error adding score, Player not found")
        }
        
    }
    
    
    func updateScore(player: Int, amount: Int) {
        if player == 1 {
            model.playerOneScore += amount
            localPlayerOneScore += amount
        } else if player == 2 {
            model.playerOneScore += amount
            localPlayerTwoScore += amount
        } else if player == 3 {
            model.playerThreeScore += amount
            localPlayerThreeScore += amount
        } else {
            print("error Updating score, player not found")
        }
    }
    
    func getPositionOfTokenSpace(at location: Location) -> CGPoint? {
        for tokenSpaceToCheck in tokenSpacesInPlay {
            if tokenSpaceToCheck.Location.col == location.col && tokenSpaceToCheck.Location.numInCol == location.numInCol && tokenSpaceToCheck.Location.posistioningNumInCol == location.posistioningNumInCol {
                return tokenSpaceToCheck.position
            }
        }
        return nil
    }
    
    func makeStartingPeices() {
        let token1 = model.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken1 = tokenNode(token: token1)
        let Location1 = Location(col: 3, numInCol: 3, posistioningNumInCol: 3)
        nodeOfToken1.tokenData.Location = Location1
        nodeOfToken1.placeTokenNode(in: getPositionOfTokenSpace(at: Location1) ?? CGPoint(x: 0, y: 0), on: self)
       removeTokenSpace(at: Location1)
         tokensInPlay.append(nodeOfToken1)
        
        let token2 = model.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken2 = tokenNode(token: token2)
        let Location2 = Location(col: 5, numInCol: 3, posistioningNumInCol: 3)
        nodeOfToken2.tokenData.Location = Location2
        nodeOfToken2.placeTokenNode(in: getPositionOfTokenSpace(at: Location2) ?? CGPoint(x: 0, y: 0), on: self)
        removeTokenSpace(at: Location2)
        tokensInPlay.append(nodeOfToken2)
        
        let token3 = model.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken3 = tokenNode(token: token3)
        let Location3 = Location(col: 4, numInCol: 5, posistioningNumInCol: 5)
        nodeOfToken3.tokenData.Location = Location3
        nodeOfToken3.placeTokenNode(in: getPositionOfTokenSpace(at: Location3) ?? CGPoint(x: 0, y: 0), on: self)
        removeTokenSpace(at: Location3)
         tokensInPlay.append(nodeOfToken3)
        
        localPlayerOneScoreLabel = SKLabelNode(text: "P1 Score is: \(localPlayerOneScore)")
        localPlayerOneScoreLabel.position = CGPoint(x: 400 , y: Int(JKGame.rect.minY) + 200)
        localPlayerOneScoreLabel.fontName = "RussoOne-Regular"
        addChild(localPlayerOneScoreLabel)
        
        
        localPlayerTwoScoreLabel = SKLabelNode(text: "P2 Score is: \(localPlayerTwoScore)")
        localPlayerTwoScoreLabel.position = CGPoint(x: 400, y: Int(JKGame.rect.maxY) - 150)
        localPlayerTwoScoreLabel.fontName = "RussoOne-Regular"
        addChild(localPlayerTwoScoreLabel)
        
        localPlayerThreeScoreLabel = SKLabelNode(text: "P3 Score is: \(localPlayerThreeScore)")
        localPlayerThreeScoreLabel.position = CGPoint(x: Int(JKGame.rect.maxX) - 400, y: Int(JKGame.rect.midY) )
        localPlayerThreeScoreLabel.fontName = "RussoOne-Regular"
        addChild(localPlayerThreeScoreLabel)
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
    
    
    
    
    

}
