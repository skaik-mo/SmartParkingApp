//
//  Message.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 29/03/2022.
//

import Foundation
import UIKit

class Message {
    var id: String?
    var message: String?
    var isSender: Bool?
    var time: Date?
    
    init(message: String?, isSender: Bool?, time: Date?) {
        self.id = UUID().uuidString
        self.message = message
        self.isSender = isSender
        self.time = time
    }
}
