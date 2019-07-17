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
    }
    
    
    
    
}
