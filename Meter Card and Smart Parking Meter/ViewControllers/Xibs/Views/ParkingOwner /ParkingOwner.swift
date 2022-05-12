//  Skaik_mo
//
//  ParkingOwner.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import UIKit

class ParkingOwner: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var parkingOwnerImage: UIImageView!
    @IBOutlet weak var nameParkingOwnerLabel: UILabel!
    @IBOutlet weak var addressParkingOwnerLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(ParkingOwner._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

    func setUpView(parking: ParkingModel?, auth: AuthModel?) {
        if let _auth = auth, let _parking = parking, let _parkingAddress = _parking.address {
            AuthManager.shared.setImage(authImage: self.parkingOwnerImage, urlImage: _auth.urlImage)
            self.nameParkingOwnerLabel.text = _auth.name
            self.addressParkingOwnerLabel.text = _parkingAddress
        }
    }

}
