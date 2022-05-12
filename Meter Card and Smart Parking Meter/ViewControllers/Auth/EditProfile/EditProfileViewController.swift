//  Skaik_mo
//
//  EditProfileViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit
import SVProgressHUD

class EditProfileViewController: UIViewController {

    @IBOutlet weak var authImage: UIImageView!

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!

    @IBOutlet weak var greenButton: GreenButton!

    var isEnableButton: Bool = true {
        didSet {
            self.greenButton.greenButton.isEnabled = self.isEnableButton
        }
    }

    var typeAuth: TypeAuth = .User {
        didSet {
            switchTypeAuth()
        }
    }

    var isLoginBySocial: Bool = false {
        didSet {
            loginBySocial()
        }
    }

    var auth: AuthModel?

    var backAuth: ((_ auth: AuthModel?) -> Void)?

    var isAuthImage: Bool?
    var dataAuth: Data?
    var dataDrivingLicense: Data?

    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
        setImage()
    }

    @IBAction func addAuthImageAction(_ sender: Any) {
        self.addImage(isAuthImage: true)
    }

}

extension EditProfileViewController {

    func setupView() {
        self.title = "Edit Profile"



        if let _typeAuth = self.auth?.typeAuth {
            self.typeAuth = _typeAuth
        }

        if let _isLoginBySocial = self.auth?.isLoginBySocial {
            self.isLoginBySocial = _isLoginBySocial
        }

        self.emailText.keyboardType = .emailAddress
        self.plateNumberText.keyboardType = .phonePad

        if let _ = auth?.urlLicense {
            self.drivingLicenseText.isSelectedText = true
        }
        self.drivingLicenseText.showCameraIcon = true
        self.drivingLicenseText.handleAddImage = {
            self.addImage(isAuthImage: false)
        }

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.save()
        }

    }

    func localized() {

    }

    func setupData() {
        if let _name = auth?.name, let _email = auth?.email, let _plateNumber = auth?.plateNumber {
            self.nameText.text = _name
            self.emailText.text = _email
            self.plateNumberText.text = _plateNumber
        }
    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage, urlImage: auth?.urlImage)
    }

    private func switchTypeAuth() {
        switch self.typeAuth {
        case .User:
            self.plateNumberText.placeholder = "Plate Number"
            self.drivingLicenseText.isHidden = false
        case .Business:
            self.plateNumberText.placeholder = "Mobile Number"
            self.drivingLicenseText.isHidden = true
        }
    }

    private func loginBySocial() {
        self.nameText.isUserInteractionEnabled = !self.isLoginBySocial
        self.emailText.isUserInteractionEnabled = !self.isLoginBySocial
    }

}

extension EditProfileViewController {

    private func checkData() -> Bool {
        if !self.nameText.text._isValidValue {
            self._showErrorAlert(message: "Enter name")
            return false
        }
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: "Enter email")
            return false
        }
        if !self.plateNumberText.text._isValidValue {
            self._showErrorAlert(message: "Enter plate number")
            return false
        }
        return true
    }

    private func getAuth() -> AuthModel? {
        guard self.checkData() else { return nil }
        return .init(id: auth?.id, name: self.nameText.text, email: self.emailText.text, password: auth?.password, plateNumber: self.plateNumberText.text, typeAuth: auth?.typeAuth, urlImage: auth?.urlImage, urlLicense: auth?.urlLicense, isLoginBySocial: self.isLoginBySocial)
    }

    private func save() {
        guard let _auth = self.getAuth() else { return }
        self.isEnableButton = false
        AuthManager.shared.setAuth(auth: _auth, dataDrivingLicense: self.dataDrivingLicense, dataAuth: self.dataAuth) { errorMessage in
            self.isEnableButton = true
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self.backAuth?(_auth)
            self._showAlertOKWithTitle(title: "Successful", message: "Your changes have been successfully saved!")
        }
    }

}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func addImage(isAuthImage: Bool) {
        self.isAuthImage = isAuthImage
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self._dismissVC()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let _data = image?.pngData() {
            if self.isAuthImage == true {
                self.authImage.image = image
                self.dataAuth = _data
            } else {
                self.drivingLicenseText.isSelectedText = true
                self.dataDrivingLicense = _data
            }
        }
    }

}
