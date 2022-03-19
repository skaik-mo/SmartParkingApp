//  Skaik_mo
//
//  ForgotPasswordViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 09/03/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailText: CustomText!
    
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

extension ForgotPasswordViewController {

    func setupView() {
        self.title = ""
        self.emailText.keyboardType = .emailAddress
        
        self.greenButton.handleButton = {
            debugPrint("Send")
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

