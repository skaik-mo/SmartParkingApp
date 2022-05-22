//  Skaik_mo
//
//  ParkingInfo.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 18/03/2022.
//

import UIKit
import GoogleMaps

class ParkingInfo: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var ratingView: Rating!

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var perHourLabel: UILabel!

    @IBOutlet weak var bookNowButton: GreenButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(ParkingInfo._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

}

extension ParkingInfo {

    func setUpView(parking: ParkingModel?) {
        ParkingManager.shared.setImage(parkingImage: self.parkingImage, urlImage: parking?.parkingImageURL)
        self.bookNowButton.setUp(typeButton: .grayButton, corner: 8)
        self.bookNowButton.handleButton = {
            let vc: SpotDetailsViewController = SpotDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.parking = parking
            vc._push()
        }

        self.ratingView.setUpRating(parking: parking, isWithDistance: false)
        guard let _parking = parking else { return }
        setInfo(parking: _parking)
        self.distanceLabel.text = "\(_parking.distance._toString(number: 2))km"

    }

    private func setInfo(parking: ParkingModel) {
        if let _price = parking.price {
            self.perHourLabel.text = "Park Booking \(_price)$ Per \(parking.isPerDay ?? false ? "Day" : "Hour")"
            self.addressLabel.text = parking.address == nil ? "No Address" : parking.address
        }
    }
}
