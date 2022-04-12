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
        self._setTitleBackBarButton()
    }

}

extension PasswordViewController {

    func setupView() {
        self.title = "Change Password"
        
        self.currentPasswordView.isPassword = true
        self.newPasswordView.isPassword = true
        self.repeatPasswordView.isPassword = true
        
        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.save()
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension PasswordViewController {

    private func checkData() -> Bool {
        if !self.currentPasswordView.text._isValidValue {
            self._showErrorAlert(message: "Enter current password")
            return false
        }
        if !self.newPasswordView.text._isValidValue {
            self._showErrorAlert(message: "Enter new password")
            return false
        }
        if !self.repeatPasswordView.text._isValidValue {
            self._showErrorAlert(message: "Enter repeat password")
            return false
        }
        if newPasswordView.text != repeatPasswordView.text {
            self._showErrorAlert(message: "New Password and Repeat Password do not match")
            return false
        }
        if newPasswordView.text == currentPasswordView.text {
            self._showErrorAlert(message: "The new password is the same as the old password")
            return false
        }
        return true
    }

    private func clearData() {
        self.currentPasswordView.text = ""
        self.newPasswordView.text = ""
        self.repeatPasswordView.text = ""
    }
    
    private func save() {
        guard self.checkData() else { return }
        AuthManager.shared.updatePassword(oldPassword: currentPasswordView.text, newPassword: newPasswordView.text) { error in
            if let _error = error {
                self._showErrorAlert(message: _error.localizedDescription)
                return
            }
            self._showAlertOKWithTitle(title: "Successful", message: "Your changes have been successfully saved!")
            
        }
    }

}
