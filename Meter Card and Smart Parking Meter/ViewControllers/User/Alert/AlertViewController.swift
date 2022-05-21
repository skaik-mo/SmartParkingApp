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
        setUpViewDidLoad()
    }
    
}

// MARK: - ViewDidLoad
extension AlertViewController {

    private func setUpViewDidLoad() {
        self.greenButton.setUp(typeButton: .greenButton)
        greenButton.handleButton = {
            self._dismissVC()
        }
    }
}

