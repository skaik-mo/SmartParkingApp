//
//  String.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension String {

    var _hexColor: UIColor {
        return UIColor.init(named: self) ?? UIColor.init(hexString: self)
    }

    var _colorcg: CGColor {
        return self._hexColor.cgColor
    }

    var _toImage: UIImage? {
        return UIImage.init(named: self)
    }

    var _localizedKey: String {
        return NSLocalizedString(self, comment: "")
    }

    var _removeWhiteSpace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var _isValidValue: Bool {
        return !self._removeWhiteSpace.isEmpty
    }

    var _toInteger: Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    var _toDouble: Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    var _toFloat: Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }

    var _toBool: Bool? {
        return (self as NSString).boolValue
    }

    var _toDate: Date? {
        return _dateWithFormate(dataFormat: dateFormat)
    }

    var _toTime: Date? {
        return _dateWithFormate(dataFormat: timeFormat)
    }

    func _dateWithFormate(dataFormat: String, timeZone: String = TimeZone.current.identifier) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = dataFormat
        formatter.timeZone = TimeZone.init(identifier: timeZone)
        return formatter.date(from: self)
    }
}
