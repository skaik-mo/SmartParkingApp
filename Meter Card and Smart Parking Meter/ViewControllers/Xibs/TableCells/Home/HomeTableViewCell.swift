//  Skaik_mo
//
//  HomeTableViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var parkingNameLabel: UILabel!

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var rejectButton: GreenButton!
    @IBOutlet weak var acceptButton: GreenButton!

    @IBOutlet weak var parkingPriceLabel: UILabel!

    @IBOutlet weak var parkingStatusLabel: UILabel!
    var isClicked = false {
        didSet {
            setClicked()
        }
    }

    var parking: ParkingModel?
    var booking: BookingModel?
    var user: AuthModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        self.customerImage.fetchImage(user?.urlImage, ic_placeholderPerson)
        if let _booking = self.booking, let _parking = self.parking, let _price = _parking.price, let _user = user {
            self.customerNameLabel.text = _user.name
            self.parkingNameLabel.text = _parking.name
            self.parkingPriceLabel.text = "$\(_price)"
            setTitleClicked(status: _booking.status)
        }
        setUpView()
    }

}

extension HomeTableViewCell {
    private func setUpView() {
        self.rejectButton.greenButton.backgroundColor = "D0021B"._hexColor

        if let status = self.booking?.status {
            self.isClicked = status.rawValue == 0 ? false : true
        }

        self.rejectButton.setUp(typeButton: .redButton, corner: 9)
        self.rejectButton.greenButton.titleLabel?.font = fontMontserratRegular12
        self.rejectButton.handleButton = {
            self.setTitleClicked(status: .Rejected)
            self.isClicked = true
            self.setStatus(status: .Rejected)
        }
        self.acceptButton.setUp(typeButton: .greenButton, corner: 9)
        self.acceptButton.greenButton.titleLabel?.font = fontMontserratRegular12
        self.acceptButton.greenButton.backgroundColor = "0D9F67"._hexColor
        self.acceptButton.handleButton = {
            self.setTitleClicked(status: .Accepted)
            self.isClicked = true
            self.setStatus(status: .Accepted)
        }
    }

    private func setTitleClicked(status: BookinsStatus) {
        self.parkingStatusLabel.text = status.getStringStatus().text
        self.parkingStatusLabel.textColor = status.getStringStatus().color
    }

    private func setClicked() {
        switch self.isClicked {
        case true:
            self.parkingStatusLabel.isHidden = false
            self.rejectButton.isHidden = true
            self.acceptButton.isHidden = true
        case false:
            self.parkingStatusLabel.isHidden = true
            self.rejectButton.isHidden = false
            self.acceptButton.isHidden = false
        }
    }

    private func setStatus(status: BookinsStatus) {
        if let _booking = self.booking, _booking.status != status {
            _booking.status = status
            BookingManager.shared.setBooking(newBooking: _booking) { errorMessage in
                if let _errorMessage = errorMessage {
                    if let vc = AppDelegate.shared?._topVC as? HomeBusinessViewController {
                        vc._showErrorAlert(message: _errorMessage)
                    }
                }
            }
        }
    }

}
