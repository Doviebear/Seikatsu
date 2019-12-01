//
//  UserDefaultsHelper.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 12/1/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation
import SpriteKit

class UserDefaultsHelper {
    static let helper = UserDefaultsHelper()
    
    var defaults = UserDefaults.standard
    
    
    func setDefaultBool(value: Bool, key: String) {
        self.defaults.set(value, forKey: key)
    }
    
    func getDefaultBool(key: String) -> Bool {
        return self.defaults.bool(forKey: key)
    }
    
    
    
}
