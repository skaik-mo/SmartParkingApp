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
    var id: String?
    var name: String?
    var imageURL: String?
    var fromDate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?
    var price: String?
    var spots: [Int]?
    var rating: Double?
    var address: String?
    var latitude: Double?
    var longitude: Double?

//    init(id: String?, name: String?, image: UIImage?, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?, price: Double?, spots: [Int]?, rating: Double? = nil, address: String?, latitude: Double?, longitude: Double?) {
//
//    }

    init(name: String?, imageURL: String? = nil, fromDate: String?, toDate: String?, fromTime: String?, toTime: String?, price: String?, spots: [Int]?, rating: Double? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.imageURL = imageURL
        self.fromDate = fromDate
        self.toDate = toDate
        self.fromTime = fromTime
        self.toTime = toTime
        self.price = price
        self.spots = spots
        self.rating = rating
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    init(name: String?, imageURL: String? = nil, rating: Double? = nil, price: String? = nil, latitude: Double?, longitude: Double?) {
        self.id = UUID().uuidString
        self.name = name
        self.imageURL = imageURL
        self.rating = rating
        self.price = price
        self.latitude = latitude
        self.longitude = longitude

        if let _latitude = latitude, let _longitude = longitude {
            GoogleMapManager.getPlaceAddressFrom(location: CLLocationCoordinate2D.init(latitude: _latitude, longitude: _longitude), completion: { address in
                    self.address = address
                })
        }

    }
    
    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
//            "id": self.id,
            "name": self.name,
            "imageURL": self.imageURL,
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
        ]
        return dictionary as [String: Any]
    }

    func setParkingImage(parkingImage: UIImageView) {
        if let _image = self.imageURL {
            parkingImage.image = _image._toImage
            return
        }
        // if no image set default image
        parkingImage.image = "demo"._toImage
    }

}



//    func setInfoParking() {
//        guard let _parking = self.parking else { return }
//        setParkingImage(parking: _parking)
//        setInfo(parking: _parking)
//        setDistance(parking: _parking)
//        setRating(parking: _parking)
//
//    }
//
//    private func setParkingImage(parking: Parking) {
//        if let _image = parking.image {
//            self.parkingImage.image = _image
//            return
//        }
//        // if no image set default image
//    }
//
//    private func setInfo(parking: Parking) {
//        if let _name = parking.name, let _pricePerHour = parking.pricePerHour {
//            self.parkingNameLabel.text = _name
//        }
//    }
//
//    private func setDistance(parking: Parking) {
//        if let _latitude = parking.latitude, let _longitude = parking.longitude {
//            let toLocation = CLLocation.init(latitude: _latitude, longitude: _longitude)
//            let distance = GoogleMapManager.getDistance(toLocation: toLocation)
//            self.distanceLabel.text = "\(distance._toString(number: 2))km Nearby"
//        }
//    }
//
//    private func setRating(parking: Parking) {
//        if let _rating = parking.rating {
//            self.ratingLabel.text = "\(_rating._toString)/5"
//            setRatingViews(rating: Int(round(_rating)))
//            return
//        }
//        // if no rating set zero
//        setRatingViews(rating: 0)
//    }
//
//    private func setRatingViews(rating: Int) {
//        let ratingViews = [self.rating1, self.rating2, self.rating3, self.rating4, self.rating5]
//        if rating == 0 {
//            ratingViews.forEach { rating in
//                rating?.backgroundColor = "DAD9E2"._hexColor
//            }
//        } else {
//            for index in 0..<ratingViews.count {
//                if index < rating {
//                    ratingViews[index]?.backgroundColor = "3FBF66"._hexColor
//                } else {
//                    ratingViews[index]?.backgroundColor = "DAD9E2"._hexColor
//                }
//            }
//
//        }
//    }
//
//}
