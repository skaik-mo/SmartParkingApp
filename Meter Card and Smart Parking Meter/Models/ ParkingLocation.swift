//
//   ParkingLocation.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import UIKit
import GoogleMaps

class Parking {
    var id: String?
    var name: String?
    var image: UIImage?
    var rating: Double?
    var address: String?
    var pricePerHour: Double?
    var latitude: Double?
    var longitude: Double?

    init(title: String?, image: UIImage? = nil, rating: Double? = nil, pricePerHour: Double? = nil, latitude: Double?, longitude: Double?) {

        self.id = UUID().uuidString
        self.name = title
        self.image = image
        self.rating = rating
        self.pricePerHour = pricePerHour
        self.latitude = latitude
        self.longitude = longitude
        
        if let _latitude = latitude, let _longitude = longitude {
            GoogleMapManager.getPlaceAddressFrom(location: CLLocationCoordinate2D.init(latitude: _latitude, longitude: _longitude), completion: { address in
                    self.address = address
                })
        }

    }

}
