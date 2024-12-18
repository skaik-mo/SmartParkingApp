//  Skaik_mo
//
//  SignUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var userButton: GreenButton!
    @IBOutlet weak var businessButton: GreenButton!

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var passwordText: CustomText!
    @IBOutlet weak var confirmPasswordText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!

    @IBOutlet weak var goHomeButton: UIButton!

    @IBOutlet weak var backButton: UIButton!

    var isNewUser: Bool = false {
        didSet {
            self.CompletingInfo()
        }
    }

    private var data: Data?

    private var imagePicker = UIImagePickerController()

    private var typeAuth: TypeAuth = .User {
        didSet {
            switchTypeAuth()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    @IBAction func goHomeScreenAction(_ sender: Any) {
        signUp()
    }

}

// MARK: - ViewDidLoad
extension SignUpViewController {

    private func setUpViewDidLoad() {
        self.title = ""

        self.typeAuth = .User

        self.emailText.keyboardType = .emailAddress
        self.passwordText.isPassword = true
        self.confirmPasswordText.isPassword = true
        self.plateNumberText.keyboardType = .phonePad
        self.drivingLicenseText.showCameraIcon = true
        self.drivingLicenseText.handleAddImage = {
            self.addImage()
        }

        self.userButton.handleButton = {
            self.typeAuth = .User
        }
        self.businessButton.handleButton = {
            self.typeAuth = .Business
        }
    }

}

extension SignUpViewController {

    private func switchTypeAuth() {
        switch self.typeAuth {
        case .User:
            self.userButton.setUp(typeButton: .greenButton)
            self.businessButton.setUp(typeButton: .grayButtonWithBorder)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.plateNumberText.placeholder = PALTE_NUMBER_TITLE
                self.drivingLicenseText.alpha = 1
            })
        case .Business:
            self.userButton.setUp(typeButton: .grayButtonWithBorder)
            self.businessButton.setUp(typeButton: .greenButton)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.plateNumberText.placeholder = MOBILE_NUMBER_TITLE
                self.drivingLicenseText.alpha = 0
            })
        }
    }

    private func CompletingInfo() {
        DispatchQueue.main.async {
            self.accountLabel.text = COMPLETE_INFO_TITLE
            self.descriptionLabel.text = ""
            self.nameText.isHidden = self.isNewUser
            self.emailText.isHidden = self.isNewUser
            self.passwordText.isHidden = self.isNewUser
            self.confirmPasswordText.isHidden = self.isNewUser
            self.backButton.isHidden = self.isNewUser
        }
    }

}

extension SignUpViewController {

    private func checkData() -> Bool {
        if !self.isNewUser {
            if !self.nameText.text._isValidValue {
                self._showErrorAlert(message: ENTER_NAME_TITLE)
                return false
            }
            if !self.emailText.text._isValidValue {
                self._showErrorAlert(message: ENTER_EMAIL_TITLE)
                return false
            }
            if !self.passwordText.text._isValidValue {
                self._showErrorAlert(message: ENTER_PASSWORD_MESSAGE)
                return false
            }
            if !self.confirmPasswordText.text._isValidValue {
                self._showErrorAlert(message: ENTER_CONFIRM_PASSWORD_MESSAGE)
                return false
            }
            if passwordText.text != confirmPasswordText.text {
                self._showErrorAlert(message: DO_NOT_MATCH_CONFIRMATION_PASSWORD_MESSAGE)
                return false
            }
        }
        if !self.plateNumberText.text._isValidValue {
            let field = self.typeAuth == .User ? PALTE_NUMBER_TITLE: MOBILE_NUMBER_TITLE
            self._showErrorAlert(message: "Enter \(field)")
            return false
        }
        if !self.drivingLicenseText.isSelectedText, self.typeAuth == .User {
            self._showErrorAlert(message: ENTER_DRIVING_LICENSE_MESSAGE)
            return false
        }
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
        if self.isNewUser, let _auth = AuthManager.shared.getLocalAuth() {
            _auth.typeAuth = self.typeAuth
            _auth.plateNumber = self.plateNumberText.text
            return _auth
        }
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
        guard let _auth = getAuth() else { return }
        if self.isNewUser {
            AuthManager.shared.setAuth(auth: _auth, dataDrivingLicense: data) { errorMessage in
                if let _errorMessage = errorMessage {
                    self._showErrorAlert(message: _errorMessage)
                    return
                }
                self.clearData()
                self.goHome()
            }
        } else {
            AuthManager.shared.signUpByEmail(auth: _auth, data: data) { auth, errorMessage in
                if let _errorMessage = errorMessage {
                    self._showErrorAlert(message: _errorMessage)
                    return
                }
                self.clearData()
                self.goHome()
            }
        }
    }

}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: { () -> Void in

        })
        let drivingLicenseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let _data = drivingLicenseImage?._jpeg(.low) {
            self.drivingLicenseText.isSelectedText = true
            self.data = _data
        }
    }

}
