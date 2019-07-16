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
    // 0 is new turn start, 1 is picked from hand
    var gameplayPhase = 0
    var selectedToken: tokenNode?
    var selectedTokenOldPosistion: CGPoint?
    
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
            }
        }
        
        for k in 1...7 {
            let col = 4
            if k != 4 {
                let tokenSpace = TokenSpace(Location: Location(col: col, numInCol: k, posistioningNumInCol: k), textureName: "circleNode")
                tokenSpace.drawNode(on: self)
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
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            for node in nodesArray {
                print("Name of node is: \(node.name)")
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
        if let nodeToPlace = selectedToken{
            selectedTokenOldPosistion = selectedToken?.position
            nodeToPlace.position = node.position
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
   
    

}
