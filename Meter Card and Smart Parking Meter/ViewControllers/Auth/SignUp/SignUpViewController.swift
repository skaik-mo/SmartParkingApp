//  Skaik_mo
//
//  SignUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit
import SVProgressHUD

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
//    @IBOutlet weak var subView: UIView!

    @IBOutlet weak var goHomeButton: UIButton!

    @IBOutlet weak var backButton: UIButton!

    var isEnableButton: Bool = true {
        didSet {
            self.goHomeButton.isEnabled = self.isEnableButton
        }
    }

    var isCompletingInfo: Bool = false {
        didSet {
            self.CompletingInfo()
        }
    }
    var auth: AuthModel?

    var data: Data?

    var imagePicker = UIImagePickerController()

    var typeAuth: TypeAuth = .User {
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
            self.plateNumberText.placeholder = "Plate Number"
            self.userButton.setUp(typeButton: .greenButton)

            self.businessButton.setUp(typeButton: .grayButtonWithBorder)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 1
//                self.subView.isHidden = false
            })
        case .Business:
            self.plateNumberText.placeholder = "Mobile Number"
            self.userButton.setUp(typeButton: .grayButtonWithBorder)

            self.businessButton.setUp(typeButton: .greenButton)

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.drivingLicenseText.alpha = 0
//                self.subView.isHidden = true

            })
        }
    }

    private func CompletingInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.accountLabel.text = "Complete information"
            self.descriptionLabel.text = ""
            self.nameText.isHidden = self.isCompletingInfo
            self.emailText.isHidden = self.isCompletingInfo
            self.passwordText.isHidden = self.isCompletingInfo
            self.confirmPasswordText.isHidden = self.isCompletingInfo
            self.backButton.isHidden = self.isCompletingInfo
        }
    }

}

extension SignUpViewController {

    private func checkData() -> Bool {
        if !self.isCompletingInfo {
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
        }
        if !self.plateNumberText.text._isValidValue {
            let field = self.typeAuth == .User ? "plate number" : "mobile number"
            self._showErrorAlert(message: "Enter \(field)")
            return false
        }
        if !self.drivingLicenseText.isSelectedText, self.typeAuth == .User {
            self._showErrorAlert(message: "Enter driving license")
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
        if self.isCompletingInfo, let _auth = auth {
            _auth.typeAuth = self.typeAuth
            _auth.plateNumber = self.plateNumberText.text
            return _auth
        }
        return .init(name: nameText.text, email: emailText.text, password: passwordText.text, plateNumber: plateNumberText.text, typeAuth: typeAuth)
    }

    private func goHome(auth: AuthModel) {
        switch self.typeAuth {
        case .User:
            let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.auth = auth
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc.auth = auth
            vc._rootPush()
        }
    }

    private func signUp() {
        guard let _auth = getAuth() else { return }
        isEnableButton = false
        SVProgressHUD.show()
        if self.isCompletingInfo {
            AuthManager.shared.setAuth(auth: _auth, dataDrivingLicense: data) { errorMessage in
                if let _errorMessage = errorMessage {
                    self._showErrorAlert(message: _errorMessage)
                } else {
                self.clearData()
                self.goHome(auth: _auth)
                }
                SVProgressHUD.dismiss()
                self.isEnableButton = true
            }
        } else {
            AuthManager.shared.signUpByEmail(auth: _auth, data: data) { auth, message in
                if let _auth = auth {
                    self.clearData()
                    self.goHome(auth: _auth)
                } else {
                self._showErrorAlert(message: message)
                }
                self.isEnableButton = true
            }
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
        let drivingLicenseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let _data = drivingLicenseImage?.pngData() {
            self.drivingLicenseText.isSelectedText = true
            self.data = _data
        }
    }

}
