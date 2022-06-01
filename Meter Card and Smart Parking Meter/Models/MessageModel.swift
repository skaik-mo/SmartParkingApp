//
//  Message.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 29/03/2022.
//

import Foundation
import UIKit

class MessageModel {
    var id: String?
    var senderID: String?
    var receiverID: String?
    var messages: [Message?] = []


    init(senderID: String?, receiverID: String?) {
        self.id = UUID.init().uuidString
        self.senderID = senderID
        self.receiverID = receiverID
    }

    init?(id: String?, dictionary: [String: Any]?) {
        guard let _id = id, let _dictionary = dictionary else { return nil }
        self.id = _id
        self.senderID = _dictionary["senderID"] as? String
        self.receiverID = _dictionary["receiverID"] as? String
        for message in (_dictionary["messages"] as? [[String: Any]?]) ?? [] {
            self.messages.append(.init(dictionary: message))
        }
    }

    func getDictionary() -> [String: Any] {
        var dic: [[String: Any]] = []
        for message in self.messages {
            if let getDictionary = message?.getDictionary() {
                dic.append(getDictionary)
            }
        }
        let dictionary: [String: Any?] = [
            "senderID": self.senderID,
            "receiverID": self.receiverID,
            "messages": dic
        ]
        return dictionary as [String: Any]
    }

    func sorted() {
        self.messages = self.messages.sorted { previous, next in
            if let _previousDate = previous?.sentDate, let _nextDate = next?.sentDate {
                return _previousDate < _nextDate
            }
            return false
        }
    }

}

class Message {
    var message: String?
    var imageURL: String?
    var sentDate: Date?
    var sender: String?
    
    init(message: String?, imageURL: String?, sentDate: Date?, sender: String?) {
        self.message = message
        self.imageURL = imageURL
        self.sentDate = sentDate
        self.sender = sender
    }

    init?(dictionary: [String: Any]?) {
        guard let _dictionary = dictionary else { return nil }
        self.message = _dictionary["message"] as? String
        self.imageURL = _dictionary["imageURL"] as? String
        self.sentDate = (_dictionary["sentDate"] as? String)?._dateWithFormate(dataFormat: dateAndTimeFormat)
        self.sender = _dictionary["sender"] as? String
    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "message": self.message,
            "imageURL": self.imageURL,
            "sentDate": self.sentDate?._string(dataFormat: dateAndTimeFormat),
            "sender": self.sender
        ]
        return dictionary as [String: Any]
    }
}
