//  Skaik_mo
//
//  ParkingCollectionViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit

class ParkingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var ratingView: Rating!

    var parking: ParkingModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        self.parkingImage.fetchImage(parking?.parkingImageURL)
        self.ratingView.setUpRating(parking: parking, isWithDistance: false, space: 4)
    }

}
