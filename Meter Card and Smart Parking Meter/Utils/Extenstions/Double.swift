//
//  Double.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 18/03/2022.
//

import Foundation

extension Double {

    var _toString: String {
        return String(format: "%.1f", self)
    }

    func _toString(number: Int) -> String {
        return String(format: "%.\(number)f", self)
    }

}
