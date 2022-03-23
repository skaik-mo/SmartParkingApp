//
//  Date.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation

extension Date {
    var _stringData: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func _string(dataFormat: String, timeZone: String = TimeZone.current.identifier) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = dataFormat
        formatter.timeZone = TimeZone.init(identifier: timeZone)
        return formatter.string(from: self)
    }
    
    func _getTime() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
}
