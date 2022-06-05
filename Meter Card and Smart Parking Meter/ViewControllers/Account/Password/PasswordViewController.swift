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

    private var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

}

// MARK: - ViewDidLoad
extension PasswordViewController {

    private func setUpViewDidLoad() {
        self.title = CHANGE_PASSWORD_TITLE

        self.auth = AuthManager.shared.getLocalAuth()
        
        self.currentPasswordView.isPassword = true
        self.newPasswordView.isPassword = true
        self.repeatPasswordView.isPassword = true

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.save()
        }
    }

}
// MARK: - ViewWillAppear
extension PasswordViewController {

    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
    }
}

extension PasswordViewController {

    private func checkData() -> Bool {
        if !self.currentPasswordView.text._isValidValue {
            self._showErrorAlert(message: ENTER_CURRENT_PASSWORD_MESSAGE)
            return false
        }
        if !self.newPasswordView.text._isValidValue {
            self._showErrorAlert(message: ENTER_NEW_PASSWORD_MESSAGE)
            return false
        }
        if !self.repeatPasswordView.text._isValidValue {
            self._showErrorAlert(message: ENTER_REPEAT_PASSWORD_MESSAGE)
            return false
        }
        if self.auth?.password != currentPasswordView.text {
            self._showErrorAlert(message: INCORRECT_CURRENT_PASSWORD_MESSAGE)
            return false
        }
        if newPasswordView.text != repeatPasswordView.text {
            self._showErrorAlert(message: DO_NOT_MATCH_REPEAT_PASSWORD_MESSAGE)
            return false
        }
        if newPasswordView.text == currentPasswordView.text {
            self._showErrorAlert(message: NEW_PASSWORD_SAME_OLD_MESSAGE)
            return false
        }
        return true
    }

    private func clearData() {
        self.currentPasswordView.text = ""
        self.newPasswordView.text = ""
        self.repeatPasswordView.text = ""
    }

    private func getAuth() -> AuthModel? {
        guard let _auth = auth, self.checkData() else { return nil }
        _auth.password = self.newPasswordView.text
        return _auth
    }

    private func save() {
        guard let _auth = self.getAuth() else { return }
        AuthManager.shared.updatePassword(auth: _auth) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self.clearData()
            self._showAlertOKWithTitle(title: SUCCESSFUL_MESSAGE, message: CHANGES_SUCCESSFUL_SAVED_MESSAGE)
        }
    }

}
