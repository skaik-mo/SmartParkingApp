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
    private var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

}

// MARK: - ViewDidLoad
extension SubmitBookingViewController {

    private func setUpViewDidLoad() {
        self.auth = AuthManager.shared.getLocalAuth()
        
        var price = ""
        if let _price = parking?.price {
            price = "(\(_price)$)"
        }
        self.titleLabel.text = "Memorial Park \(price)"

        self.selectNumberOfParking.title.textColor = "929292"._hexColor
        self.selectNumberOfParking.setUpNumberOfParking(typeSpotButton: .selectedFill, title: SELECT_SPOT_TITLE, spots: self.parking?.spots)

        self.selectDate.selectionType = .date
        self.selectDate.fromImageView.isHidden = true
        self.selectDate.toImageView.isHidden = true

        self.selectTime.selectionType = .time
        self.selectTime.fromImageView.isHidden = true
        self.selectTime.toImageView.isHidden = true

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.save()
        }
    }

}

extension SubmitBookingViewController {
    private func checkData() -> Bool {
        let isDateFieldsEmpty = self.selectDate.isEmptyFields()
        let isTimeFieldsEmpty = self.selectTime.isEmptyFields()

        if self.selectNumberOfParking.selectedSpot == nil {
            self._showErrorAlert(message: SELECT_SPOT_TITLE)
            return false
        }
        if isDateFieldsEmpty.status {
            self._showErrorAlert(message: isDateFieldsEmpty.errorMessage)
            return false
        }
        if isTimeFieldsEmpty.status {
            self._showErrorAlert(message: isTimeFieldsEmpty.errorMessage)
            return false
        }
        if !(self.auth?.id?._isValidValue ?? false) {
            self._showErrorAlert(message: TRY_LOGIN_MESSAGE)
            return false
        }
        return true
    }

    private func getBooking() -> BookingModel? {
        guard self.checkData() else { return nil }

        return .init(userID: auth?.id, businessID: parking?.uid, parkingID: parking?.id, spot: selectNumberOfParking.selectedSpot, fromDate: selectDate.fromText, toDate: selectDate.toText, fromTime: selectTime.fromText, toTime: selectTime.toText, status: .Pending)
    }

    private func save() {
        guard let _booking = self.getBooking() else { return }
        BookingManager.shared.addBooking(parking: self.parking, newBooking: _booking) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self._dismissVC()
        }
    }
}
