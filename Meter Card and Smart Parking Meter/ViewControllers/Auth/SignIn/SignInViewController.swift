//  Skaik_mo
//
//  SignInViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var emailText: CustomText!
    @IBOutlet weak var passwordText: CustomText!

    @IBOutlet weak var goHomeButton: UIButton!
    @IBOutlet weak var AppleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!

    var isEnableButton: Bool = true {
        didSet {
            self.goHomeButton.isEnabled = self.isEnableButton
            self.AppleButton.isEnabled = self.isEnableButton
            self.facebookButton.isEnabled = self.isEnableButton
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

extension SignInViewController {

    func setupView() {
        self.emailText.keyboardType = .emailAddress
        self.passwordText.isPassword = true

        signUpButton._setAttributedString(rang: "Sign up", attributed: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "3FBF66")])

    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension SignInViewController {
    private func checkData() -> Bool {
        if !self.emailText.text._isValidValue {
            self._showErrorAlert(message: "Enter email")
            return false
        }
        if !self.passwordText.text._isValidValue {
            self._showErrorAlert(message: "Enter password")
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
            vc.auth = auth
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc.auth = auth
            vc._rootPush()
        case .none:
            break
        }
    }

    private func signIn() {
        guard let auth = getAuth() else { return }
        self.isEnableButton = false
        AuthManager.shared.signInByEmail(auth: auth) { auth, message in
            if let _auth = auth {
                self.clearData()
                self.goHome(auth: _auth)
            } else {
                self._showErrorAlert(message: message)
            }
            self.isEnableButton = true

        }
    }

    private func loginByFacebook() {
        self.isEnableButton = false
        AuthManager.shared.signInByFacebook(vc: self) { auth, isRegister, message in
            if let _auth = auth {
                self.clearData()
                if let _isRegister = isRegister, _isRegister {
                    self.isEnableButton = true
                    let vc: SignUpViewController = SignUpViewController._instantiateVC(storyboard: self._authStoryboard)
                    vc.isCompletingInfo = true
                    vc.auth = _auth
                    vc._rootPush()
                } else {
                    self.goHome(auth: _auth)
                }
                return
            }
            self._showErrorAlert(message: message)
        }
    }

}

