//  Skaik_mo
//
//  EditProfileViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var authImage: UIImageView!

    @IBOutlet weak var nameText: CustomText!
    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var plateNumberText: CustomText!
    @IBOutlet weak var drivingLicenseText: CustomText!

    @IBOutlet weak var greenButton: GreenButton!

    var typeAuth: TypeAuth = .User {
        didSet {
            switchTypeAuth()
        }
    }
    
    private var auth: AuthModel?
    private var isAuthImage: Bool?
    private var dataAuth: Data?
    private var dataDrivingLicense: Data?

    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
        setUpData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
        setImage()
    }

    @IBAction func addAuthImageAction(_ sender: Any) {
        self.addImage(isAuthImage: true)
    }

}

// MARK: - ViewDidLoad
extension EditProfileViewController {

    private func setUpViewDidLoad() {
        self.title = "Edit Profile"

        self.auth = AuthManager.shared.getLocalAuth()

        if let _typeAuth = self.auth?.typeAuth {
            self.typeAuth = _typeAuth
        }

        loginBySocial()

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

    private func setUpData() {
        if let _name = auth?.name, let _email = auth?.email, let _plateNumber = auth?.plateNumber {
            self.nameText.text = _name
            self.emailText.text = _email
            self.plateNumberText.text = _plateNumber
        }
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
        let isLoginBySocial = self.auth?.isLoginBySocial ?? true
        self.nameText.isUserInteractionEnabled = !isLoginBySocial
        self.emailText.isUserInteractionEnabled = !isLoginBySocial
    }

}

// MARK: - viewWillAppear
extension EditProfileViewController {
    
    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
    }
    
    private func setImage() {
        self.authImage.fetchImageWithActivityIndicator(auth?.urlImage, ic_placeholderPerson)
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
        self.setAuth()
        return true
    }

    private func setAuth() {
        auth?.name =  self.nameText.text
        auth?.email =  self.emailText.text
        auth?.plateNumber =  self.plateNumberText.text
    }

    private func save() {
        guard self.checkData() else { return }
        AuthManager.shared.setAuth(auth: self.auth, dataDrivingLicense: self.dataDrivingLicense, dataAuth: self.dataAuth) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self._showAlertOKWithTitle(title: "Successful", message: "Your changes have been successfully saved!")
        }
    }

}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private func addImage(isAuthImage: Bool) {
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
        if let _data = image?._jpeg(.low) {
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
