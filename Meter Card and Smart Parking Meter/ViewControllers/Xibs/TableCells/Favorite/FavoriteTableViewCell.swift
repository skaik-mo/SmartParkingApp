//  Skaik_mo
//
//  FavoriteTableViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit
import GoogleMaps

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var parkingImage: UIImageView!
    
    @IBOutlet weak var ratingView: Rating!
    
    var parking: Parking?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configerCell() {
//        parking = Parking.init(title: "dc", image: nil, rating: 3.3, pricePerHour: nil, latitude: 1.222, longitude: 34.33)
        if let _parking = parking {
            _parking.setParkingImage(parkingImage: self.parkingImage)
        }
        self.ratingView.setUpRating(parking: parking, space: 9)
    }
    
}
