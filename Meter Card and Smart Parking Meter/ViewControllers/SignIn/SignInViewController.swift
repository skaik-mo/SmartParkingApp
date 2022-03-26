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
        let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
        vc._rootPush()
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


