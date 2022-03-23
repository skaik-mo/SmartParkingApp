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


    var parking: Parking?

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

    @IBAction func bookNowAction(_ sender: Any) {
        SpotDetailsViewController._push { viewController in
            let vc = viewController as? SpotDetailsViewController
            vc?.parking = self.parking
        }

    }

}

extension ParkingInfo {
    func setUpView() {
        self.ratingView.setUpRating(parking: parking, isWithDistance: false)
        guard let _parking = self.parking else { return }
        setParkingImage(parking: _parking)
        setInfo(parking: _parking)
        setDistance(parking: _parking)

    }

    private func setParkingImage(parking: Parking) {
        if let _image = parking.image {
            self.parkingImage.image = _image
            return
        }
        // if no image set default image
    }

    private func setInfo(parking: Parking) {
        if let _pricePerHour = parking.pricePerHour {
            self.perHourLabel.text = "Park Booking \(_pricePerHour._toString)$ Per Hour"
            self.addressLabel.text = parking.address == nil ? "No Address" : parking.address
        }
    }

    private func setDistance(parking: Parking) {
        if let _latitude = parking.latitude, let _longitude = parking.longitude {
            let toLocation = CLLocation.init(latitude: _latitude, longitude: _longitude)
            let distance = GoogleMapManager.getDistance(toLocation: toLocation)
            self.distanceLabel.text = "\(distance._toString(number: 2))km"
        }
    }

   

}
