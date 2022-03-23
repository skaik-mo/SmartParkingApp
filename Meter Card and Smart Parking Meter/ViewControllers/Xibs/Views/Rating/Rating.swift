//  Skaik_mo
//
//  Rating.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit
import GoogleMaps

class Rating: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var heightView: NSLayoutConstraint!
    
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var rating1: UIView!
    @IBOutlet weak var rating2: UIView!
    @IBOutlet weak var rating3: UIView!
    @IBOutlet weak var rating4: UIView!
    @IBOutlet weak var rating5: UIView!

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

    func setUpRating(parking: Parking?, isWithDistance: Bool = true, space spaceBetweenComponents: CGFloat = 6 ) {
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
        var ratingStr = "0"
        if let _rating = rating {
            ratingStr = _rating._toString
            setRatingViews(rating: Int(round(_rating)))

        } else {
            // if no rating set zero
            setRatingViews(rating: 0)
        }
        self.ratingLabel.text = "\(ratingStr)/5"
    }

    private func setRatingViews(rating: Int) {
        let ratingViews = [self.rating1, self.rating2, self.rating3, self.rating4, self.rating5]
        if rating == 0 {
            ratingViews.forEach { rating in
                rating?.backgroundColor = "DAD9E2"._hexColor
            }
        } else {
            for index in 0..<ratingViews.count {
                if index < rating {
                    ratingViews[index]?.backgroundColor = "3FBF66"._hexColor
                } else {
                    ratingViews[index]?.backgroundColor = "DAD9E2"._hexColor
                }
            }

        }
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
