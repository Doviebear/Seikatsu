//
//  Token.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation

class Token: Codable {
    var flowerType: String
    var birdType: String
    var position: Location?
    var player: Int?
    
    init(flowerType: String, birdType: String) {
        self.flowerType = flowerType
        self.birdType = birdType
    }
    
}


class koiPond: Token {
    
    
}
