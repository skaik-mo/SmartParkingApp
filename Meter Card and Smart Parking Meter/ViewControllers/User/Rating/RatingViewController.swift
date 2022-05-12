//  Skaik_mo
//
//  RatingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {

    @IBOutlet weak var ratingView: CosmosView!

    @IBOutlet weak var greenButton: GreenButton!

    var parking: ParkingModel?
    var auth: AuthModel?

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

extension RatingViewController {

    func setupView() {
        ratingView.settings.fillMode = .full

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.addRating()
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension RatingViewController {

    private func checkData() -> Bool {
        if (!(self.auth?.id?._isValidValue ?? false) || !(self.parking?.id?._isValidValue ?? false)) {
            self._showErrorAlert(message: "error")
            return false
        }
        return true
    }

    private func getRating() -> RatingModel? {
        guard checkData() else { return nil }
        return .init(userID: self.auth?.id, parkingID: self.parking?.id, rating: self.ratingView.rating)
    }

    private func addRating() {
        guard let _rating = getRating() else { return }
        RatingManager.shared.setParking(rating: _rating, parking: self.parking) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self._dismissVC()
        }
    }

}
