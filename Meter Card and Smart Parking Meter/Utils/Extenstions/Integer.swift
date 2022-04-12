//
//  Integer.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 08/04/2022.
//

import Foundation

extension Int {
    var _toString: String {
        return String(self)
    }
    
    var _toDouble: Double {
        return Double(self)
    }
    
    var getTypeAuth: TypeAuht {
        if self == 0 {
            return TypeAuht.User
        }
        return TypeAuht.Business
    }
}

