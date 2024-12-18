//  Skaik_mo
//
//  ForgotPasswordViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 09/03/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailText: CustomText!

    @IBOutlet weak var greenButton: GreenButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

}

// MARK: - ViewDidLoad
extension ForgotPasswordViewController {

    private func setUpViewDidLoad() {
        self.title = ""
        self.emailText.keyboardType = .emailAddress

        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.resetPassword()
        }
    }
}

extension ForgotPasswordViewController {
    private func checkData() -> Bool {
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: ENTER_EMAIL_TITLE)
            return false
        }
        return true
    }

    private func clearData() {
        self.emailText.text = ""
    }

    private func getEmail() -> String? {
        guard self.checkData() else { return nil }
        return self.emailText.text.lowercased()
    }

    private func goSignIn() {
        self._pop()
    }

    private func resetPassword() {
        guard let email = getEmail() else { return }
        AuthManager.shared.resetPassword(email: email) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            } else {
                self.clearData()
                self._showAlert(title: RESET_PASSWORD_TITLE, message: "We have sent a password reset email to your email address:\n\(email).\nPlease check your inbox to continue.") {
                    self.goSignIn()
                }
            }
        }
    }

}
