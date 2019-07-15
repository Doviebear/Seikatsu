//
//  GrabBag.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation

class GrabBag: Codable {
    var tokens = [Token]()
    var flowers = ["Yellow","Blue","Pink","Purple"]
    var birds = ["Yellow","Green","Blue","Red"]
    
    
    init() {
        for flower in flowers {
            for bird in birds {
                for _ in 1...4 {
                    tokens.append(Token(flowerType: flower, birdType: bird))
                }
            }
        }
        for _ in 1...4 {
            tokens.append(koiPond(flowerType: "Pond", birdType: "Pond"))
        }
        tokens.shuffle()
    }
    
    func drawToken() -> Token{
        let chosenToken = tokens[0]
        tokens.remove(at: 0)
        return chosenToken
    }
}
