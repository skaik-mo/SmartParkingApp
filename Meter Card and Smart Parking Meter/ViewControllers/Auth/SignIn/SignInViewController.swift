//  Skaik_mo
//
//  SignInViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var passwordText: CustomText!

    @IBOutlet weak var goHomeButton: UIButton!
    @IBOutlet weak var AppleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    @IBAction func goForgotPasswordAction(_ sender: Any) {
        let vc: ForgotPasswordViewController = ForgotPasswordViewController._instantiateVC(storyboard: self._authStoryboard)
        vc._push()
    }

    @IBAction func goSignUpAction(_ sender: Any) {
        let vc: SignUpViewController = SignUpViewController._instantiateVC(storyboard: self._authStoryboard)
        vc._push()

    }

    @IBAction func goHomeScreenAction(_ sender: Any) {
        signIn()
    }

    @IBAction func loginByFacebook(_ sender: Any) {
        self.loginByFacebook()
    }

    @IBAction func loginByApple(_ sender: Any) {
    }

}

// MARK: - ViewDidLoad
extension SignInViewController {

    private func setUpViewDidLoad() {
        self.emailText.keyboardType = .emailAddress
        self.passwordText.isPassword = true

        signUpButton._setAttributedString(rang: SIGN_UP_TITLE, attributed: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "3FBF66")])
    }

}

extension SignInViewController {

    private func checkData() -> Bool {
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: ENTER_EMAIL_TITLE)
            return false
        }
        if !self.passwordText.text._isValidValue {
            self._showErrorAlert(message: ENTER_PASSWORD_MESSAGE)
            return false
        }
        return true
    }

    private func clearData() {
        self.emailText.text = ""
        self.passwordText.text = ""
    }

    private func getAuth() -> AuthModel? {
        guard self.checkData() else { return nil }
        return .init(email: emailText.text, password: passwordText.text)
    }

    private func goHome(auth: AuthModel) {
        switch auth.typeAuth {
        case .User:
            let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc._rootPush()
        case .none:
            break
        }
    }

    private func signIn() {
        guard let auth = getAuth() else { return }
        AuthManager.shared.signInByEmail(auth: auth) { auth, errorMessage in
            if let _auth = auth {
                self.clearData()
                self.goHome(auth: _auth)
                return
            }
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            }
        }
    }

    private func loginByFacebook() {
        AuthManager.shared.signInByFacebook(vc: self) { auth, isNewUser, message in
            if let _auth = auth {
                if isNewUser {
                    // Complete info
                    let vc: SignUpViewController = SignUpViewController._instantiateVC(storyboard: self._authStoryboard)
                    vc.isNewUser = true
                    vc._rootPush()
                } else {
                    self.goHome(auth: _auth)
                }
                return
            }
            if let _message = message {
                self._showErrorAlert(message: _message)
            }
        }
    }

}

