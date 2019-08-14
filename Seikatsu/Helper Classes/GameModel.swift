//
//  GameModel.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation

struct GameModel: Codable {
    var grabBag: GrabBag
    var TokensInPlay = [Token]()
    var turnNum = 0
    var playerTurn = 1
    var playerOneHand = [Token]()
    var playerTwoHand = [Token]()
    var playerThreeHand = [Token]()
    var playerOneScore = 0
    var playerTwoScore = 0
    var playerThreeScore = 0
    
    
    init(){
        self.grabBag = GrabBag()
        for i in 1...3 {
            for _ in 1...2 {
                let token = self.grabBag.drawToken()
                if i == 1 {
                    token.player = 1
                    self.playerOneHand.append(token)
                } else if i == 2 {
                    token.player = 2
                    self.playerTwoHand.append(token)
                } else if i == 3 {
                    token.player = 3
                    self.playerThreeHand.append(token)
                }
            }
        }
        let token1 = self.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken1 = tokenNode(token: token1)
        let Location1 = Location(col: 3, numInCol: 3, posistioningNumInCol: 3)
        nodeOfToken1.tokenData.Location = Location1
        self.TokensInPlay.append(nodeOfToken1.tokenData)
       
        
        let token2 = self.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken2 = tokenNode(token: token2)
        let Location2 = Location(col: 5, numInCol: 3, posistioningNumInCol: 3)
        nodeOfToken2.tokenData.Location = Location2
        self.TokensInPlay.append(nodeOfToken2.tokenData)
        
        let token3 = self.grabBag.drawToken(canBeKoiPond: false)
        let nodeOfToken3 = tokenNode(token: token3)
        let Location3 = Location(col: 4, numInCol: 5, posistioningNumInCol: 5)
        nodeOfToken3.tokenData.Location = Location3
        self.TokensInPlay.append(nodeOfToken3.tokenData)
        
    }
    
    
    
    
}
