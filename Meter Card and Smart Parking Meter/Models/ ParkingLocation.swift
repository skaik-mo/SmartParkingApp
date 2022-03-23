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

    func setParkingImage(parkingImage: UIImageView) {
        if let _image = self.image {
            parkingImage.image = _image
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
