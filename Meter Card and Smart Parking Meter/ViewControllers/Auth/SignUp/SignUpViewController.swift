//  Skaik_mo
//
//  SignUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

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
    
    @IBOutlet weak var goHomeButton: UIButton!

    var isEnableButton: Bool = true {
        didSet {
            self.goHomeButton.isEnabled = self.isEnableButton
        }
    }
    
    var data: Data?
    var authImage: UIImage?
    
    var imagePicker = UIImagePickerController()

    var typeAuth: TypeAuht = .User {
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
        signUp()
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
        self.drivingLicenseText.handleAddImage = {
            self.addImage()
        }

        switchTypeAuth()

        self.userButton.handleButton = {
            self.typeAuth = .User
            debugPrint("userButton")
        }
        self.businessButton.handleButton = {
            self.typeAuth = .Business
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
        switch self.typeAuth {
        case .User:
            self.userButton.setUp(typeButton: .greenButton)

            self.businessButton.setUp(typeButton: .grayButtonWithBorder)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 1
                self.subView.isHidden = false
            })
        case .Business:
            self.userButton.setUp(typeButton: .grayButtonWithBorder)

            self.businessButton.setUp(typeButton: .greenButton)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 0
                self.subView.isHidden = true

            })
        }
    }

    private func checkData() -> Bool {
        if !self.nameText.text._isValidValue {
            self._showErrorAlert(message: "Enter name")
            return false
        }
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: "Enter email")
            return false
        }
        if !self.passwordText.text._isValidValue {
            self._showErrorAlert(message: "Enter password")
            return false
        }
        if !self.confirmPasswordText.text._isValidValue {
            self._showErrorAlert(message: "Enter confirm password")
            return false
        }
        if passwordText.text != confirmPasswordText.text {
            self._showErrorAlert(message: "Password and confirmation do not match")
            return false
        }
        if !self.plateNumberText.text._isValidValue {
            self._showErrorAlert(message: "Enter plate number")
            return false
        }
//        if !self.drivingLicenseText.text._isValidValue {
//            debugPrint("sdv")
//         return false
//        }
        return true

    }

    private func clearData() {
        self.nameText.text = ""
        self.emailText.text = ""
        self.passwordText.text = ""
        self.confirmPasswordText.text = ""
        self.plateNumberText.text = ""
    }

    private func getAuth() -> AuthModel? {
        guard self.checkData() else { return nil }
        return .init(name: nameText.text, email: emailText.text, password: passwordText.text, plateNumber: plateNumberText.text, typeAuth: typeAuth)
    }

    private func goHome() {
        switch self.typeAuth {
        case .User:
            let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc._rootPush()
        }
    }

    private func signUp() {
        guard let auth = getAuth() else { return }
        isEnableButton = false
        AuthManager.shared.signUpByEmail(auth: auth, data: data) { auth, message in
            self.isEnableButton = true
            if let _ = auth {
                self.clearData()
                self.goHome()
                return
            }
            self._showErrorAlert(message: message)
        }
    }

}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: { () -> Void in

        })
        self.authImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.data = authImage?.pngData()
    }

}
