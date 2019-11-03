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
    var rowScores = [[Int]]()
    
    
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
        let Location1 = Location(col: 3, numInCol: 3, posistioningNumInCol: 3)
        token1.Location = Location1
        self.TokensInPlay.append(token1)
       
        
        let token2 = self.grabBag.drawToken(canBeKoiPond: false)
        let Location2 = Location(col: 5, numInCol: 3, posistioningNumInCol: 3)
        token2.Location = Location2
        self.TokensInPlay.append(token2)
        
        let token3 = self.grabBag.drawToken(canBeKoiPond: false)
        let Location3 = Location(col: 4, numInCol: 5, posistioningNumInCol: 5)
        token3.Location = Location3
        self.TokensInPlay.append(token3)
        
        for _ in 0...2 {
            let arrayOfScores = [0,0,1,1,1,0,0]
            rowScores.append(arrayOfScores)
        }
    }
    
    
    
    
}
