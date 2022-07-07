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
    private var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
        setupData()
        setImage()
    }

    @IBAction func logoutAction(_ sender: Any) {
        logout()
    }
}

// MARK: - ViewDidLoad
extension ProfileViewController {

    private func setUpViewDidLoad() {
        self.title = MY_PROFILE_TITLE

        self.editProfileButton.setUp(typeButton: .greenButton, corner: 22.5)
        self.editProfileButton.handleButton = {
            let vc: EditProfileViewController = EditProfileViewController._instantiateVC(storyboard: self._accountStoryboard)
            vc._push()
        }

        self.messageButton.handleButton = {
            let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.typeView = .Messages
            vc._push()
        }

        self.changePasswordButton.handleButton = {
            let vc: PasswordViewController = PasswordViewController._instantiateVC(storyboard: self._accountStoryboard)
            vc._push()
        }
    }

}

// MARK: - ViewWillAppear
extension ProfileViewController {

    private func setUpViewWillAppear() {
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self._setTitleBackBarButton()

        self.auth = AuthManager.shared.getLocalAuth()
        if let _typeAuht = auth?.typeAuth {
            self.typeAuth = _typeAuht
        }

        if let _isLoginBySocial = self.auth?.isLoginBySocial {
            self.changePasswordButton.isHidden = _isLoginBySocial
        }
    }

    private func setupData() {
        guard let _auth = self.auth else { return }
        self.ownerNameLabel.text = _auth.name
        self.emailLabel.text = _auth.email
    }

    private func setImage() {
        self.authImage.fetchImage(auth?.urlImage, ic_placeholderPerson)
    }
}

extension ProfileViewController {

    private func switchAuth() {
        switch self.typeAuth {
        case .User:
            self.favoritesButton.isHidden = false
            self.favoritesButton.handleButton = {
                let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
                vc.typeView = .Favorites
                vc._push()
            }

            self.myBookingsButton.titleLabel.text = MY_BOOKINGS_TITLE
            self.myBookingsButton.handleButton = {
                let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
                vc.typeView = .Bookings
                vc._push()
            }
        case .Business:
            self.favoritesButton.isHidden = true

            self.myBookingsButton.titleLabel.text = MY_PARK_TITLE
            self.myBookingsButton.handleButton = {
                let vc: MyParkingsViewController = MyParkingsViewController._instantiateVC(storyboard: self._businessStoryboard)
                vc._push()
            }
        }
    }

    private func logout() {
        self._showAlert(title: ALERT_TITLE, message: CONFIRM_LOGOUT_MESSAGE, buttonAction1: {
            AuthManager.shared.logout { errorMessage in
                if let _errorMessage = errorMessage {
                    self._showErrorAlert(message: _errorMessage)
                } else {
                    let vc = GoSignInOrUpViewController._instantiateVC(storyboard: self._authStoryboard)
                    vc._rootPush()
                }
            }
        }, buttonAction2: nil)
    }

}
