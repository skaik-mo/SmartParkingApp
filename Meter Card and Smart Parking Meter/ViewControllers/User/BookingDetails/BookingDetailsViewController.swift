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

    @IBOutlet weak var parkingOwnerView: ParkingOwner!

    @IBOutlet weak var numberOfParking: NumberOfParking!


    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    @IBOutlet weak var cancelOrAcceptButton: GreenButton!
    @IBOutlet weak var rejectButton: GreenButton!

    @IBOutlet weak var bottomView: UIView!

    var booking: BookingModel?
    var parking: ParkingModel?
    var auth: AuthModel?
    var typeAuth: TypeAuth = .User

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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

        GoogleMapManager.initParkingLoction(parking: parking, mapView: mapView)

        self.ratingView.setUpRating(parking: parking, space: 12)

        self.numberOfParking.typeParkingView = .fill
        self.numberOfParking.title.text = "Spot"

        self.selectDate.selectionType = .date
        self.selectDate.title.text = "Date"
        self.selectDate.isHiddenIcons = true

        self.selectTime.selectionType = .time
        self.selectTime.title.text = "Time"
        self.selectTime.isHiddenIcons = true

        self.checkStatus()
    }

    func setupData() {
        ParkingManager.shared.setImage(parkingImage: self.parkingImage, urlImage: parking?.parkingImageURL)

        self.numberOfParking.selectedSpot(spot: self.booking?.spot)

        self.selectDate.setData(from: self.booking?.fromDate, to: self.booking?.toDate)

        self.selectTime.setData(from: self.booking?.fromTime, to: self.booking?.toTime)
    }

    func fetchData() {

    }

}


extension BookingDetailsViewController {

    private func switchAuth() {
        switch self.typeAuth {
        case .User:
            self.title = "Booking Details"

            self.parkingStatusLabel.isHidden = false
            self.setTitleStatus()

            if let _uid = self.parking?.uid {
                AuthManager.shared.getAuth(id: _uid) { auth, message in
                    if let _auth = auth {
                        self.parkingOwnerView.setUpView(parking: self.parking, auth: _auth)
                    }
                }
            }
            self.rejectButton.isHidden = true

            self.cancelOrAcceptButton.setUp(typeButton: .greenButton, corner: 10)
            self.cancelOrAcceptButton.greenButton.setTitle("Cancel", for: .normal)

            self.cancelOrAcceptButton.handleButton = {
                // Cancel Action
                debugPrint("Cancel Action")
                self.deleteBookings()
            }

        case .Business:
            self.title = "Order Details"
            self.parkingStatusLabel.isHidden = true

            self.parkingOwnerView.setUpView(parking: self.parking, auth: auth)

            self.rejectButton.isHidden = false
            self.rejectButton.setUp(typeButton: .redButton, corner: 5)
            self.rejectButton.handleButton = {
                // Reject Action
                debugPrint("Reject Action")
                self.setStatus(status: .Rejected)
            }

            self.cancelOrAcceptButton.setUp(typeButton: .greenButton, corner: 8)
            self.cancelOrAcceptButton.greenButton.setTitle("Accept", for: .normal)

            self.cancelOrAcceptButton.handleButton = {
                // Accept Action
                debugPrint("Accept Action")
                self.setStatus(status: .Accepted)
            }
        }
    }

    private func setTitleStatus() {
        switch self.booking?.status {
        case .Pending:
            self.parkingStatusLabel.text = "Pending"
            self.parkingStatusLabel.textColor = "616161"._hexColor
            break
        case .Completed:
            self.parkingStatusLabel.text = "Completed"
            self.parkingStatusLabel.textColor = "616161"._hexColor
            break
        case .Accepted:
            self.parkingStatusLabel.text = "Accepted"
            self.parkingStatusLabel.textColor = "0D9F67"._hexColor
            break
        case .Rejected:
            self.parkingStatusLabel.text = "Rejected"
            self.parkingStatusLabel.textColor = "D6243A"._hexColor
            break
        case .none:
            self.parkingStatusLabel.text = ""
            break
        }
    }

    private func checkStatus() {
        if self.booking?.status == .Pending {
            bottomView.isHidden = false
        } else {
            bottomView.isHidden = true
        }
    }

    private func setStatus(status: BookinsStatus) {
        if let _booking = self.booking, _booking.status != status {
            _booking.status = status
            self.checkStatus()
            BookingManager.shared.setBooking(newBooking: _booking) { errorMessage in
                if let _errorMessage = errorMessage {
                    self._showErrorAlert(message: _errorMessage)
                    return
                }
            }
        }
    }

    private func deleteBookings() {
        BookingManager.shared.deleteBooking(booking: self.booking) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self._pop()
        }

    }

}

