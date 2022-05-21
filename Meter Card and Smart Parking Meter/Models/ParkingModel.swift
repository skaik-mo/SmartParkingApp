//
//   ParkingModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import UIKit
import GoogleMaps

class ParkingModel {
    var uid: String? // user id
    var id: String?
    var name: String?
    var parkingImageURL: String?
    var parkLicenseimageURL: String?
    var fromDate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?
    var price: String?
    var spots: Int?
    var rating: Double?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var isPerDay: Bool?

    init(uid: String?, name: String?, parkingImageURL: String? = nil, parkLicenseimageURL: String? = nil, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?, price: String?, spots: Int?, rating: Double? = nil, latitude: Double? = nil, longitude: Double? = nil, isPerDay: Bool?) {
        self.uid = uid
        self.id = UUID().uuidString
        self.name = name
        self.parkingImageURL = parkingImageURL
        self.parkLicenseimageURL = parkLicenseimageURL
        self.fromDate = fromDate
        self.toDate = toDate
        self.fromTime = fromTime
        self.toTime = toTime
        self.price = price
        self.spots = spots
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
        self.isPerDay = isPerDay

        if let _latitude = latitude, let _longitude = longitude {
            GoogleMapManager.getPlaceAddressFrom(location: CLLocationCoordinate2D.init(latitude: _latitude, longitude: _longitude), completion: { address in
                    self.address = address
                })
        }
    }

    convenience init(uid: String?, name: String?, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?, price: String?, spots: Int?, latitude: Double? = nil, longitude: Double? = nil, isPerDay: Bool?) {
        self.init(uid: uid, name: name, parkingImageURL: nil, parkLicenseimageURL: nil, fromDate: fromDate, toDate: toDate, fromTime: fromTime, toTime: toTime, price: price, spots: spots, rating: nil, latitude: latitude, longitude: longitude, isPerDay: isPerDay)
    }

    init?(id: String?, dictionary: [String: Any]?) {
        guard let _id = id, let _dictionary = dictionary else { return nil }
        self.id = _id
        self.uid = _dictionary["uid"] as? String
        self.name = _dictionary["name"] as? String
        self.parkingImageURL = _dictionary["parkingImageURL"] as? String
        self.parkLicenseimageURL = _dictionary["parkLicenseimageURL"] as? String
        self.fromDate = _dictionary["fromDate"] as? String
        self.toDate = _dictionary["toDate"] as? String
        self.fromTime = _dictionary["fromTime"] as? String
        self.toTime = _dictionary["toTime"] as? String
        self.price = _dictionary["price"] as? String
        self.spots = _dictionary["spots"] as? Int
        self.rating = _dictionary["rating"] as? Double
        self.latitude = _dictionary["latitude"] as? Double
        self.longitude = _dictionary["longitude"] as? Double
        self.address = _dictionary["address"] as? String
        self.isPerDay = (_dictionary["isPerDay"] as? Int) == 0 ? true : false
    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "uid": self.uid,
            "name": self.name,
            "parkingImageURL": self.parkingImageURL,
            "parkLicenseimageURL": self.parkLicenseimageURL,
            "fromDate": self.fromDate,
            "toDate": self.toDate,
            "fromTime": self.fromTime,
            "toTime": self.toTime,
            "price": self.price,
            "spots": self.spots,
            "rating": self.rating,
            "address": self.address,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "isPerDay": self.isPerDay ?? false ? 0 : 1,
        ]
        return dictionary as [String: Any]
    }

    func compareDate(fromDate from: String?, toDate to: String?) -> Bool {
        return Helper.compareDate(fromDate1: self.fromDate, toDate1: self.toDate, fromDate2: from, toDate2: to)
    }

    func compareTime(fromTime from: String?, toTime to: String?) -> Bool {
        return Helper.compareTime(fromTime1: self.fromTime, toTime1: self.toTime, fromTime2: from, toTime2: to)
    }

    func isAvailableDateAndTime(booking: BookingModel) -> (status: Bool, message: String?) {
        if !self.compareDate(fromDate: booking.fromDate, toDate: booking.toDate) {
            var message = "Date not available"
            if let _from = self.fromDate, let _to = self.toDate {
                message = "Date available between \(_from) to \(_to)"
            }
            return (false, message)
        } else if !self.compareTime(fromTime: booking.fromTime, toTime: booking.toTime) {
            var message = "Time not available"
            if let _from = self.fromTime, let _to = self.toTime {
                message = "Time available between \(_from) to \(_to)"
            }
            return (false, message)
        } else {
            return (true, nil)
        }
    }
}

