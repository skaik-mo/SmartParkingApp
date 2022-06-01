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

    var parking: ParkingModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        self.parkingImage.fetchImageWithActivityIndicator(parking?.parkingImageURL, ic_placeholderParking)
        self.ratingView.setUpRating(parking: parking, space: 9)
    }

}
