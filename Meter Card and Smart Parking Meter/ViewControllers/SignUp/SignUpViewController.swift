//  Skaik_mo
//
//  SignUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

enum TypeAuht {
    case User
    case Business
}

class SignUpViewController: UIViewController {


    @IBOutlet weak var userButton: GreenButton!
    @IBOutlet weak var businessButton: GreenButton!

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var passwordText: CustomText!
    @IBOutlet weak var confirmPasswordText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!
    @IBOutlet weak var subView: UIView!

    var user = 0

    var typeAyth: TypeAuht = .User {
        didSet {
            switchTypeAuth()
        }
    }


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
        switch self.typeAyth {
        case .User:
            let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc._rootPush()
        }
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

        switchTypeAuth()

        self.userButton.handleButton = {
            self.typeAyth = .User
            debugPrint("userButton")
        }
        self.businessButton.handleButton = {
            self.typeAyth = .Business
            debugPrint("businessButton")
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}


extension SignUpViewController {
    private func switchTypeAuth() {
        switch self.typeAyth {
        case .User:
            self.userButton.greenButton.backgroundColor = "3FBF66"._hexColor
            self.businessButton.greenButton.backgroundColor = "FAFAFA"._hexColor

            self.userButton.greenButton.setTitleColor(.white, for: .normal)
            self.businessButton.greenButton.setTitleColor(.black, for: .normal)

            self.userButton.layer.borderWidth = 0
            self.userButton.layer.borderColor = UIColor.clear.cgColor
            self.businessButton.layer.borderWidth = 1
            self.businessButton.layer.borderColor = "E2E2E2"._hexColor.cgColor

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 1
                self.subView.isHidden = false
            })
        case .Business:
            self.userButton.greenButton.backgroundColor = "FAFAFA"._hexColor
            self.businessButton.greenButton.backgroundColor = "3FBF66"._hexColor

            self.userButton.greenButton.setTitleColor(.black, for: .normal)
            self.businessButton.greenButton.setTitleColor(.white, for: .normal)

            self.userButton.layer.borderWidth = 1
            self.userButton.layer.borderColor = "E2E2E2"._hexColor.cgColor
            self.businessButton.layer.borderWidth = 0
            self.businessButton.layer.borderColor = UIColor.clear.cgColor

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 0
                self.subView.isHidden = true

            })
        }
    }
}
