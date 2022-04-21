//  Skaik_mo
//
//  SubmitBookingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import UIKit

class SubmitBookingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var selectNumberOfParking: NumberOfParking!

    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    @IBOutlet weak var greenButton: GreenButton!

    var parking: ParkingModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension SubmitBookingViewController {

    func setupView() {
        var price = ""
        if let _price = parking?.price {
            price = "(\(_price)$)"
        }
        self.titleLabel.text = "Memorial Park \(price)"

        self.selectNumberOfParking.typeParkingView = .fill
        self.selectNumberOfParking.title.text = "Select Spot"
        self.selectNumberOfParking.title.textColor = "929292"._hexColor

        self.selectDate.selectionType = .date
        self.selectDate.fromImageView.isHidden = true
        self.selectDate.toImageView.isHidden = true

        self.selectTime.selectionType = .time
        self.selectTime.fromImageView.isHidden = true
        self.selectTime.toImageView.isHidden = true

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {

        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

