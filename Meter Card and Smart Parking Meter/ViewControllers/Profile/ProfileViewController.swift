//  Skaik_mo
//
//  ProfileViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var parkingOwnerImage: UIImageView!

    @IBOutlet weak var ownerNameLabel: UILabel!

    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var messageButton: ProfileButton!
    @IBOutlet weak var favoritesButton: ProfileButton!
    @IBOutlet weak var myBookingsButton: ProfileButton!
    @IBOutlet weak var changePasswordButton: ProfileButton!

    var typeAuth: TypeAuht = .User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self._setTitleBackBarButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func editProfileAction(_ sender: Any) {
        let vc: EditProfileViewController = EditProfileViewController._instantiateVC(storyboard: self._authStoryboard)
        vc._push()
    }

}

extension ProfileViewController {

    func setupView() {
        self.title = "My Profile"

        switchAuth()
        
        self.messageButton.handleButton = {
            let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.typeView = .Messages
            vc._push()
        }
        
        self.changePasswordButton.handleButton = {
            let vc: PasswordViewController = PasswordViewController._instantiateVC(storyboard: self._authStoryboard)
            vc._push()
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

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
            
            self.myBookingsButton.titleLabel.text = "My Bookings"
            self.myBookingsButton.handleButton = {
                // My Bookings Action
                debugPrint("My Bookings Action")
                let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
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
                vc._push()
            }
        }
    }
    
}
