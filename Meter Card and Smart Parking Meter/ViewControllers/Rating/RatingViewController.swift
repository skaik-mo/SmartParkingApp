//  Skaik_mo
//
//  RatingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit
import HCSStarRatingView

class RatingViewController: UIViewController {

    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    @IBOutlet weak var greenButton: GreenButton!
    
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
//        self.ratingView.allowsHalfStars = true
//        self.ratingView.accurateHalfStars = true
        
        self.greenButton.handleButton = {
            debugPrint("Rating: \(self.ratingView.value)")
            self._dismissVC()
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

