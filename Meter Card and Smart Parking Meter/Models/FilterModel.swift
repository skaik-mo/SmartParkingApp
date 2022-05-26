//
//  FilterModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 03/05/2022.
//

import Foundation
import GoogleMaps

class FilterModel {
    var distance: Double?
    var fromDate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?

    init(distance: Double?, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?) {
        self.distance = distance
        self.fromDate = fromDate
        self.toDate = toDate
        self.fromTime = fromTime
        self.toTime = toTime
    }

    // Is the chosen distance smaller or equal to the distance between the parking location and the user's location
    func compareDistance(latitude: Double?, longitude: Double?) -> Bool {
        guard let _distance = self.distance?._toString(number: 2), let _latitude = latitude, let _longitude = longitude else { return false }
        if GoogleMapManager.shared.getDistance(toLocation: CLLocation.init(latitude: _latitude, longitude: _longitude))._toString(number: 2) <= _distance {
            return true
        }
        return false
    }

    func compareDate(fromDate from: String?, toDate to: String?) -> Bool {
        return Helper.compareDate(fromDate1: self.fromDate, toDate1: self.toDate, fromDate2: from, toDate2: to)
    }

    func compareTime(fromTime from: String?, toTime to: String?) -> Bool {
        return Helper.compareTime(fromTime1: self.fromTime, toTime1: self.toTime, fromTime2: from, toTime2: to)
    }

}
