//
//  BookingModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 04/05/2022.
//

import Foundation
import UIKit

enum BookinsStatus: Int {
    case Pending = 0
    case Accepted = 1
    case Rejected = 2
    case Completed = 3

    func getStatus(status: Int?) -> BookinsStatus {
        switch status {
        case 1:
            return .Accepted
        case 2:
            return .Rejected
        case 3:
            return .Completed
        default:
            return .Pending
        }
    }
    
    func getStringStatus() -> (text: String, color: UIColor) {
        switch self {
        case .Pending:
            return ("Pending", "616161"._hexColor)
        case .Accepted:
            return ("Accepted", "0D9F67"._hexColor)
        case .Rejected:
            return ("Rejected", "D6243A"._hexColor)
        case .Completed:
            return ("Completed", "616161"._hexColor)
        }
    }
}

class BookingModel {
    var id: String? // for booking
    var userID: String? // for user
    var businessID: String? // for business
    var parkingID: String? // for parking
    var spot: Int?
    var fromDate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?
    var status: BookinsStatus = .Pending

    init(userID: String?, businessID: String?, parkingID: String?, spot: Int?, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?, status: BookinsStatus) {
        self.id = UUID().uuidString
        self.userID = userID
        self.businessID = businessID
        self.parkingID = parkingID
        self.spot = spot
        self.fromDate = fromDate
        self.toDate = toDate
        self.fromTime = fromTime
        self.toTime = toTime
        self.status = status
    }

    init?(id: String?, dictionary: [String: Any]?) {
        guard let _id = id, let _dictionary = dictionary else { return nil }
        self.id = _id
        self.userID = _dictionary["userID"] as? String
        self.businessID = _dictionary["businessID"] as? String
        self.parkingID = _dictionary["parkingID"] as? String
        self.spot = _dictionary["spot"] as? Int
        self.fromDate = _dictionary["fromDate"] as? String
        self.toDate = _dictionary["toDate"] as? String
        self.fromTime = _dictionary["fromTime"] as? String
        self.toTime = _dictionary["toTime"] as? String
        self.status = status.getStatus(status: _dictionary["status"] as? Int)

    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "userID": self.userID,
            "businessID": self.businessID,
            "parkingID": self.parkingID,
            "spot": self.spot,
            "fromDate": self.fromDate,
            "toDate": self.toDate,
            "fromTime": self.fromTime,
            "toTime": self.toTime,
            "status": self.status.rawValue
        ]
        return dictionary as [String: Any]
    }

    func compareDate(fromDate from: String?, toDate to: String?) -> Bool {
        return Helper.compareDate(fromDate1: self.fromDate, toDate1: self.toDate, fromDate2: from, toDate2: to)
    }

    func compareTime(fromTime from: String?, toTime to: String?) -> Bool {
        return Helper.compareTime(fromTime1: self.fromTime, toTime1: self.toTime, fromTime2: from, toTime2: to)
    }

}
