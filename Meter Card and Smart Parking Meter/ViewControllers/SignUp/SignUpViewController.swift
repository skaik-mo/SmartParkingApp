//  Skaik_mo
//
//  SignUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var greenButton: GreenButton!

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var passwordText: CustomText!
    @IBOutlet weak var confirmPasswordText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!
    
    var user = 0
    
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
    
    @IBAction func goHomeScreenAction(_ sender: Any) {
        let vc: HomeViewController = HomeViewController.instantiateVC(storyboard: self._userStoryboard)
        vc._rootPush()
    }
    
}

extension SignUpViewController {

    func setupView() {
        self.title = ""
 
        self.emailText.keyboardType = .emailAddress
        self.passwordText.isPassword = true
        self.confirmPasswordText.isPassword = true
        self.plateNumberText.keyboardType = .phonePad
        self.drivingLicenseText.showCameraIcon = true

        
        self.greenButton.handleButton = {
            debugPrint("User2")
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

