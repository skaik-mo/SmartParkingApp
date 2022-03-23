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

    var parking: Parking?

    enum TypeParkingStatus: String {
        case pending = "616161"
        case rejected = "D6243A"
        case accepted = "0D9F67"
    }
    
    var typeParkingStatus: TypeParkingStatus = .pending
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        parking = Parking.init(title: "dc", image: nil, rating: 3.3, pricePerHour: 10, latitude: 1.222, longitude: 34.33)
        if let _parking = self.parking {
            self.parkingNameLabel.text = _parking.name
            setInfo(parking: _parking)
            setParkingStatus()
        }
    }


}

extension BookingTableViewCell {
    private func setInfo(parking: Parking) {
        if let _pricePerHour = parking.pricePerHour, let address = parking.address {
            self.parkingPriceLabel.text = "\(_pricePerHour._toString)$"
            self.parkingAddressLabel.text = address
            return
        }
        self.parkingPriceLabel.text = ""
        self.parkingAddressLabel.text = "No Address"
    }
    
    private func setParkingStatus() {
        self.parkingStatusLabel.textColor = self.typeParkingStatus.rawValue._hexColor
        switch self.typeParkingStatus {
        case .pending:
            self.parkingStatusLabel.text = "Pending"
        case .rejected:
            self.parkingStatusLabel.text = "Rejected"
        case .accepted:
            self.parkingStatusLabel.text = "Accepted"
        }
        
    }
}
