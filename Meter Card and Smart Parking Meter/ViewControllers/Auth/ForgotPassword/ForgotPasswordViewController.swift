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
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension ForgotPasswordViewController {

    func setupView() {
        self.title = ""
        self.emailText.keyboardType = .emailAddress
        
        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            self.signIn()
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension ForgotPasswordViewController {
    private func checkData() -> Bool {
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: "Enter email")
            return false
        }
        return true
    }

    private func clearData() {
        self.emailText.text = ""
    }

    private func getEmail() -> String? {
        guard self.checkData() else { return nil }
        return self.emailText.text
    }

    private func goSignIn() {
        self._pop()
    }

    private func signIn() {
        guard let email = getEmail() else { return }
        AuthManager.shared.resetPassword(email: email) { error in
            if let _error = error {
                self._showErrorAlert(message: _error.localizedDescription)
            } else {
                self.clearData()
                self._showAlert(title: "Your password reset email has been sent!", message: "We have sent a password reset email to your email address:\n\(email).\nPlease check your inbox to continue.") {
                    self.goSignIn()
                }
            }
        }
    }

}
