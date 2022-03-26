//  Skaik_mo
//
//  BookingDetailsViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit
import GoogleMaps

class BookingDetailsViewController: UIViewController {

    @IBOutlet weak var parkingStatusLabel: UILabel!

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var ratingView: Rating!

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var numberOfParking: NumberOfParking!


    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    @IBOutlet weak var cancelOrAcceptButton: GreenButton!
    @IBOutlet weak var rejectButton: GreenButton!

    var parking: Parking?
    var typeAuth: TypeAuht = .User

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
    }

}

extension BookingDetailsViewController {

    func setupView() {
        switchAuth()

        GoogleMapManager.initParkingLoction(parkingLocation: parking, mapView: mapView)

        self.ratingView.setUpRating(parking: parking, space: 12)

        self.parking?.setParkingImage(parkingImage: self.parkingImage)

        numberOfParking.typeParkingView = .fill
        numberOfParking.title.text = "Spot"


        self.selectDate.selectionType = .date
        self.selectDate.title.text = "Date"
        self.selectDate.isHiddenIcons = true


        self.selectTime.selectionType = .time
        self.selectTime.title.text = "Time"
        self.selectTime.isHiddenIcons = true

    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}


extension BookingDetailsViewController {

    private func switchAuth() {
        self.rejectButton.corner = 5
        self.cancelOrAcceptButton.corner = 5

        switch self.typeAuth {
        case .User:
            self.title = "Booking Details"
            self.parkingStatusLabel.isHidden = false
            
            self.rejectButton.isHidden = true

            self.cancelOrAcceptButton.corner = 10
            self.cancelOrAcceptButton.greenButton.setTitle("Cancel", for: .normal)

            self.cancelOrAcceptButton.handleButton = {
                // Cancel Action
                debugPrint("Cancel Action")
                self._pop()
            }

        case .Business:
            self.title = "Order Details"
            self.parkingStatusLabel.isHidden = true

            self.rejectButton.isHidden = false
            self.rejectButton.greenButton.backgroundColor = "D0021B"._hexColor

            self.rejectButton.handleButton = {
                // Reject Action
                debugPrint("Reject Action")
            }

            self.cancelOrAcceptButton.corner = 5
            self.cancelOrAcceptButton.greenButton.setTitle("Accept", for: .normal)

            self.cancelOrAcceptButton.handleButton = {
                // Accept Action
                debugPrint("Accept Action")
            }
        }
    }

}

