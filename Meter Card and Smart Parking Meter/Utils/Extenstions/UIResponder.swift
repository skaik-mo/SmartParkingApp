//
//  UIResponder.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIResponder {
    static var _id: String {
        return String(describing: self)
    }
    
}
