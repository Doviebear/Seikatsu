//
//  Token.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation

class Token: Codable, Equatable {
    var flowerType: String
    var birdType: String
    var Location: Location?
    var player: Int?
    
    init(flowerType: String, birdType: String) {
        self.flowerType = flowerType
        self.birdType = birdType
    }
    
    func Print() -> String {
       return "Flower type: \(self.flowerType), bird type: \(self.birdType), location: \(String(describing: self.Location)), player: \(String(describing: self.player))"
    }
    
    static func ==(token1: Token, token2: Token) -> Bool {
        if token1.flowerType == token2.flowerType && token1.birdType == token2.birdType && token1.Location == token2.Location && token1.player == token2.player {
            return true
        } else {
            return false
        }
    }
    
}


class koiPond: Token {
    
    
}
