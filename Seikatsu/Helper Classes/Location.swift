//
//  Location.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation

struct Location: Codable, Equatable {
    var col: Int
    var numInCol: Int
    var posistioningNumInCol: Int
    
    static func ==(loc1: Location, loc2: Location) -> Bool {
        if loc1.col == loc2.col && loc1.numInCol == loc2.numInCol && loc1.posistioningNumInCol == loc2.posistioningNumInCol {
            return true
        } else {
            return false
        }
    }
    
}
