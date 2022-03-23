//  Skaik_mo
//
//  AlertViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import UIKit

class AlertViewController: UIViewController {

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

extension AlertViewController {

    func setupView() {
        greenButton.handleButton = {
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

