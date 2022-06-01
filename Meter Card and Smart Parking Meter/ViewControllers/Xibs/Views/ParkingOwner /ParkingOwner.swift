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

    private var sender: AuthModel?

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

    func setUpView(parking: ParkingModel?, senderID: String?) {
        AuthManager.shared.getAuth(id: senderID) { auth, message in
            self.sender = auth
            if let _sender = self.sender, let _parking = parking, let _parkingAddress = _parking.address {
                self.parkingOwnerImage.fetchImageWithActivityIndicator(_sender.urlImage, ic_placeholderPerson)
                self.nameParkingOwnerLabel.text = _sender.name
                self.addressParkingOwnerLabel.text = _parkingAddress
            }
        }
    }


    @IBAction func messageAction(_ sender: Any) {
        let vc: MessageViewController = MessageViewController._instantiateVC(storyboard: self._accountStoryboard)
        vc.sender = self.sender
        vc._push()
    }

    @IBAction func callAction(_ sender: Any) {
        if let phoneNumber = self.sender?.plateNumber {
            self.callNumber(phoneNumber: phoneNumber)
        }
    }

    private func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}
