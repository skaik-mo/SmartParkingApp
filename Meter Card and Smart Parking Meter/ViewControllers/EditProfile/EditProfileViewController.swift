//  Skaik_mo
//
//  EditProfileViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!
    
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
        self._setTitleBackBarButton()
    }

}

extension EditProfileViewController {

    func setupView() {
        self.title = "Edit Profile"
        
        self.emailText.keyboardType = .emailAddress
        self.plateNumberText.keyboardType = .phonePad
        self.drivingLicenseText.showCameraIcon = true

        
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

