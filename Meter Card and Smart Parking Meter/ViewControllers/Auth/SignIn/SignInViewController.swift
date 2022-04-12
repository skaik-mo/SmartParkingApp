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

    var isEnableButton: Bool = true {
        didSet {
            self.goHomeButton.isEnabled = self.isEnableButton
        }
    }

    var typeAuth: TypeAuht? = .none {
        didSet {
            self.goHome()
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

    private func goHome() {
        switch self.typeAuth {
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
        self.isEnableButton = false
        AuthManager.shared.signInByEmail(auth: auth) { auth, message in
            self.isEnableButton = true
            if let _auth = auth {
                self.clearData()
                self.typeAuth = _auth.typeAuth
                return
            }
            self._showErrorAlert(message: message)
        }
    }

    private func loginByFacebook() {
        AuthManager.shared.signInByFacebook(vc: self) { auth, message in
            if let _auth = auth {
                self.clearData()
                self.typeAuth = _auth.typeAuth
                return
            }
            self._showErrorAlert(message: message)
        }
    }

}

