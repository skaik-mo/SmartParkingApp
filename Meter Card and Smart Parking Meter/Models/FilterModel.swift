//
//  FilterModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 03/05/2022.
//

import Foundation
import GoogleMaps

class FilterModel {
    var distance: Double = 0
    var fromDate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?

    init() {
    }

    // Is the chosen distance smaller or equal to the distance between the parking location and the user's location
    private func compareDistance(latitude: Double?, longitude: Double?) -> Bool {
        guard let _latitude = latitude, let _longitude = longitude else { return false }
        if GoogleMapManager.shared.getDistance(toLocation: CLLocation.init(latitude: _latitude, longitude: _longitude))._toString(number: 2) <= self.distance._toString(number: 2) {
            return true
        }
        return false
    }

    private func compareDate(fromDate from: String?, toDate to: String?) -> Bool {
        return Helper.compareDate(fromDate1: from, toDate1: to, fromDate2: self.fromDate, toDate2: self.toDate)
    }

    private func compareTime(fromTime from: String?, toTime to: String?) -> Bool {
        return Helper.compareTime(fromTime1: from, toTime1: to, fromTime2: self.fromTime, toTime2: self.toTime)
    }

    func getParkings(_ parkings: [ParkingModel]) -> [ParkingModel] {
        if self.distance > 0 {
            let filtersDistance = parkings.filter { parking in
                return self.compareDistance(latitude: parking.latitude, longitude: parking.longitude)
            }
            if let _filtersDateAndTime = filtersDateAndTime(filtersDistance) {
                return _filtersDateAndTime
            }
            return filtersDistance
        }
        return self.filtersDateAndTime(parkings) ?? []
    }

    private func filtersDateAndTime(_ parkings: [ParkingModel]) -> [ParkingModel]? {
        if self.fromDate != nil {
            return parkings.filter { parking in
                return self.compareDate(fromDate: parking.fromDate, toDate: parking.toDate) && self.compareTime(fromTime: parking.fromTime, toTime: parking.toTime)
            }
        }
        return nil
    }

}
