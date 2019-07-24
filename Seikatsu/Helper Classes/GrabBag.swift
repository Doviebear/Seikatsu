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
    var flowers = ["Orange","Purple","Blue","Yellow"]
    var birds = ["Pink","Grey","Green","Red"]
    
    
    init() {
        for flower in flowers {
            for bird in birds {
                for _ in 1...2 {
                    tokens.append(Token(flowerType: flower, birdType: bird))
                }
            }
        }
        // adding Koi Ponds
        
        for _ in 1...4 {
            tokens.append(koiPond(flowerType: "pond", birdType: "pond"))
        }
        
        tokens.shuffle()
    }
    
    func drawToken(canBeKoiPond: Bool = true) -> Token{
        var chosenToken = tokens[0]
        if !canBeKoiPond {
            for (index,token) in tokens.enumerated() {
                if token.birdType != "pond" {
                    chosenToken = token
                    tokens.remove(at: index)
                    break
                }
            }
        } else {
            chosenToken = tokens[0]
            tokens.remove(at: 0)
        }
        return chosenToken
    }
}
