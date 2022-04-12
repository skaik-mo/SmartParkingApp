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

    let auth = AuthManager.shared.getLocalAuth()

    var data: Data?

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

}

extension EditProfileViewController {

    func setupView() {
        self.title = "Edit Profile"

        self.emailText.keyboardType = .emailAddress
        self.plateNumberText.keyboardType = .phonePad
        self.drivingLicenseText.showCameraIcon = true
        self.drivingLicenseText.handleAddImage = {
            self.addImage()
        }

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.save()
        }

    }

    func localized() {

    }

    func setupData() {
        if let _name = auth.name, let _email = auth.email, let _plateNumber = auth.plateNumber {
            self.nameText.text = _name
            self.emailText.text = _email
            self.plateNumberText.text = _plateNumber
        }
    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage)
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

//    private func clearData() {
//        self.nameText.text = ""
//        self.emailText.text = ""
//        self.plateNumberText.text = ""
//    }

    private func getAuth() -> Bool {
        guard self.checkData() else { return false }
        self.auth.name = self.nameText.text
        self.auth.email = self.emailText.text
        self.auth.plateNumber = self.plateNumberText.text
        return true
    }

    private func save() {
        guard self.getAuth() else { return }
        AuthManager.shared.setAuth(auth: self.auth, data: self.data) { error in
            if let _error = error {
                self._showErrorAlert(message: _error.localizedDescription)
                return
            }
            self._showAlertOKWithTitle(title: "Successful", message: "Your changes have been successfully saved!")
        }
    }

}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.authImage.image = image
        self.data = image?.pngData()
    }

}
