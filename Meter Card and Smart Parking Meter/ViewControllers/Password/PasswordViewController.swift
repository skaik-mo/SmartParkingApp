//  Skaik_mo
//
//  PasswordViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordView: CustomText!
    @IBOutlet weak var newPasswordView: CustomText!
    @IBOutlet weak var repeatPasswordView: CustomText!

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

extension PasswordViewController {

    func setupView() {
        self.title = "Change Password"
        
        self.currentPasswordView.isPassword = true
        self.newPasswordView.isPassword = true
        self.repeatPasswordView.isPassword = true
        
        self.greenButton.handleButton = {
            debugPrint("Save")
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

