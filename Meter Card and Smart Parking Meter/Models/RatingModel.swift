//
//  RatingModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 11/05/2022.
//

import Foundation

class RatingModel {
    var userID: String?
    var parkingID: String?
    var rating: Double?

    init(userID: String?, parkingID: String?, rating: Double?) {
        self.userID = userID
        self.parkingID = parkingID
        self.rating = rating
    }

    init?(dictionary: [String: Any]?) {
        guard let _dictionary = dictionary else { return nil }
        self.userID = _dictionary["userID"] as? String
        self.parkingID = _dictionary["parkingID"] as? String
        self.rating = _dictionary["rating"] as? Double
    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "userID": self.userID,
            "parkingID": self.parkingID,
            "rating": self.rating,
        ]
        return dictionary as [String: Any]
    }

}
