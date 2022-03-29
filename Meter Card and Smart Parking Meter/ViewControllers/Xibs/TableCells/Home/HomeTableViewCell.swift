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
        didSet{
            setClicked()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configerCell() {
        setUpView()
    }
    
}

extension HomeTableViewCell {
    private func setUpView() {
        self.rejectButton.greenButton.backgroundColor = "D0021B"._hexColor
        
        self.isClicked = false
        
        self.rejectButton.setUp(typeButton: .redButton, corner: 9)
        self.rejectButton.handleButton = {
            self.setTitleClicked(parkingStatus: "Rejected", statusColor: self.rejectButton.greenButton.backgroundColor)
            self.isClicked = true
        }
        self.acceptButton.setUp(typeButton: .greenButton, corner: 9)
        self.acceptButton.handleButton = {
            self.setTitleClicked(parkingStatus: "Accepted", statusColor: self.acceptButton.greenButton.backgroundColor)
            self.isClicked = true
        }
    }
    
    private func setTitleClicked(parkingStatus: String = "", statusColor: UIColor? = .clear) {
        self.parkingStatusLabel.text = parkingStatus
        self.parkingStatusLabel.textColor = statusColor
    }
    
    private func setClicked() {
        switch self.isClicked {
        case true:
            self.parkingStatusLabel.alpha = 1
            self.rejectButton.alpha = 0
            self.acceptButton.alpha = 0
        case false:
            self.parkingStatusLabel.alpha = 0
            self.rejectButton.alpha = 1
            self.acceptButton.alpha = 1
        }
    }
    
    
//    private func setClicked() {
//        UIView.animate(withDuration: 0.5) {
//            switch self.isClicked {
//            case true:
//                self.parkingStatusLabel.alpha = 1
//                self.rejectButton.greenButton.alpha = 0
//                self.acceptButton.greenButton.alpha = 0
//            case false:
//                self.parkingStatusLabel.alpha = 0
//                self.rejectButton.greenButton.alpha = 1
//                self.acceptButton.greenButton.alpha = 1
//            }
//        }
//    }
    
}
