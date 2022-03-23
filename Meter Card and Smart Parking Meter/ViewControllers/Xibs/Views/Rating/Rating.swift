//  Skaik_mo
//
//  Rating.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit
import GoogleMaps
import Cosmos

class Rating: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var heightView: NSLayoutConstraint!

    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var middleView: UIView!

    @IBOutlet weak var ratingView: CosmosView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(Rating._id, owner: self, options: [:])
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

extension Rating {

    func setUpRating(parking: Parking?, isWithDistance: Bool = true, space spaceBetweenComponents: CGFloat = 6) {
        self.heightView.constant = spaceBetweenComponents
        setParkingName(name: parking?.name)
        setRating(rating: parking?.rating)
        setDistance(parking: parking, isWithDistance: isWithDistance)
    }

    private func setParkingName(name: String?) {
        if let _name = name {
            self.parkingNameLabel.text = _name
        }
    }

    private func setRating(rating: Double?) {
        self.ratingView.settings.fillMode = .full
        var value: Double = 0
        if let _rating = rating {
            value = _rating
        }
        self.ratingView.rating = value
        self.ratingLabel.text = "\(value)/5"
    }

    private func setDistance(parking: Parking?, isWithDistance: Bool) {
        if let _latitude = parking?.latitude, let _longitude = parking?.longitude, isWithDistance {
            self.middleView.isHidden = false
            let toLocation = CLLocation.init(latitude: _latitude, longitude: _longitude)
            let distance = GoogleMapManager.getDistance(toLocation: toLocation)
            self.distanceLabel.text = "\(distance._toString(number: 2))km Nearby"
            return
        }
        self.middleView.isHidden = true
        self.distanceLabel.text = ""
    }


}
