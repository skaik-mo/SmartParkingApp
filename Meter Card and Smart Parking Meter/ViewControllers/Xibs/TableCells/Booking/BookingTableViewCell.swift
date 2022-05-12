//  Skaik_mo
//
//  BookingTableViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var parkingStatusLabel: UILabel!

    @IBOutlet weak var parkingAddressLabel: UILabel!
    @IBOutlet weak var parkingPriceLabel: UILabel!

    var parking: ParkingModel?
    var booking: BookingModel?

    var typeBookingStatus: BookinsStatus = .Pending

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        if let _parking = self.parking, let _status = self.booking?.status {
            self.parkingNameLabel.text = _parking.name
            setInfo(parking: _parking)

            self.typeBookingStatus = _status
            setParkingStatus()
        }
    }


}

extension BookingTableViewCell {
    private func setInfo(parking: ParkingModel) {
        if let _price = parking.price, let address = parking.address {
            self.parkingPriceLabel.text = "$\(_price)"
            self.parkingAddressLabel.text = address
            return
        }
        self.parkingPriceLabel.text = ""
        self.parkingAddressLabel.text = "No Address"
    }

    private func setParkingStatus() {
        switch self.typeBookingStatus {
        case .Completed:
            self.parkingStatusLabel.text = "Completed"
            self.parkingStatusLabel.textColor = "616161"._hexColor
        case .Pending:
            self.parkingStatusLabel.text = "Pending"
            self.parkingStatusLabel.textColor = "616161"._hexColor
        case .Accepted:
            self.parkingStatusLabel.text = "Accepted"
            self.parkingStatusLabel.textColor = "0D9F67"._hexColor
        case .Rejected:
            self.parkingStatusLabel.text = "Rejected"
            self.parkingStatusLabel.textColor = "D6243A"._hexColor
        }

    }
}
