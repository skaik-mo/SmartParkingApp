//  Skaik_mo
//
//  ProfileViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var authImage: UIImageView!

    @IBOutlet weak var ownerNameLabel: UILabel!

    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var messageButton: ProfileButton!
    @IBOutlet weak var favoritesButton: ProfileButton!
    @IBOutlet weak var myBookingsButton: ProfileButton!
    @IBOutlet weak var changePasswordButton: ProfileButton!

    @IBOutlet weak var editProfileButton: GreenButton!

    var typeAuth: TypeAuth = .User {
        didSet {
            switchAuth()
        }
    }
    var auth: AuthModel?
    var backAuth: ((_ auth: AuthModel?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self._setTitleBackBarButton()
        setupData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backAuth?(auth)
    }

    @IBAction func logoutAction(_ sender: Any) {
        logout()
    }
}

extension ProfileViewController {

    func setupView() {
        self.title = "My Profile"

        if let _typeAuht = auth?.typeAuth {
            self.typeAuth = _typeAuht
        }
        
        self.editProfileButton.setUp(typeButton: .greenButton, corner: 22.5)
        self.editProfileButton.handleButton = {
            let vc: EditProfileViewController = EditProfileViewController._instantiateVC(storyboard: self._authStoryboard)
            vc.auth = self.auth
            vc.backAuth = { getAuth in
                self.auth = getAuth
                self.setupData()
            }
            vc._push()
        }

        self.messageButton.handleButton = {
            let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.auth = self.auth
            vc.typeView = .Messages
            vc._push()
        }

        if let _isLoginBySocial = self.auth?.isLoginBySocial {
            self.changePasswordButton.isHidden = _isLoginBySocial
        }
        self.changePasswordButton.handleButton = {
            let vc: PasswordViewController = PasswordViewController._instantiateVC(storyboard: self._authStoryboard)
            vc.auth = self.auth
            vc.backAuth = { getAuth in
                self.auth = getAuth
//                self.setupData()
            }
            vc._push()
        }
    }

    func localized() {

    }

    func setupData() {
        setImage()
        guard let _auth = self.auth else { return }
        self.ownerNameLabel.text = _auth.name
        self.emailLabel.text = _auth.email
    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage, urlImage: self.auth?.urlImage)
    }

}

extension ProfileViewController {

    private func switchAuth() {
        switch self.typeAuth {
        case .User:
            self.favoritesButton.isHidden = false
            self.favoritesButton.handleButton = {
                let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
                vc.auth = self.auth
                vc.typeView = .Favorites
                vc._push()
            }

            self.myBookingsButton.titleLabel.text = "My Bookings"
            self.myBookingsButton.handleButton = {
                // My Bookings Action
                debugPrint("My Bookings Action")
                let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
                vc.auth = self.auth
                vc.typeView = .Bookings
                vc._push()
            }
        case .Business:
            self.favoritesButton.isHidden = true
            self.myBookingsButton.titleLabel.text = "My Park"
            self.myBookingsButton.handleButton = {
                // My Park Action
                debugPrint("My Park Action")
                let vc: MyParkingsViewController = MyParkingsViewController._instantiateVC(storyboard: self._businessStoryboard)
                vc.auth = self.auth
                vc._push()
            }
        }
    }

    private func logout() {
        AuthManager.shared.logout { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            } else {
                let vc = GoSignInOrUpViewController._instantiateVC(storyboard: self._authStoryboard)
                vc._rootPush()
            }
        }
    }

}
