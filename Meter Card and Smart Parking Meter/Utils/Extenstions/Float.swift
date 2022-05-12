//
//  Float.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/03/2022.
//

import Foundation

extension Float {
    
    var _toString: String {
        return String(format:"%.2f", self)
    }
    
    var _toDouble: Double {
        return Double(self)
    }
}
