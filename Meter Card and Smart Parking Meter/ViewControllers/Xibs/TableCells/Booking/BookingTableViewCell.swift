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
        self.parkingAddressLabel.text = NO_ADDRESS_TITLE
    }

    private func setParkingStatus() {
        switch self.typeBookingStatus {
        case .Completed:
            self.parkingStatusLabel.text = COMPLETED_TITLE
            self.parkingStatusLabel.textColor = "616161"._hexColor
        case .Pending:
            self.parkingStatusLabel.text = PENDING_TITLE
            self.parkingStatusLabel.textColor = "616161"._hexColor
        case .Accepted:
            self.parkingStatusLabel.text = ACCEPTED_TITLE
            self.parkingStatusLabel.textColor = "0D9F67"._hexColor
        case .Rejected:
            self.parkingStatusLabel.text = REJECTED_TITLE
            self.parkingStatusLabel.textColor = "D6243A"._hexColor
        }

    }
}
