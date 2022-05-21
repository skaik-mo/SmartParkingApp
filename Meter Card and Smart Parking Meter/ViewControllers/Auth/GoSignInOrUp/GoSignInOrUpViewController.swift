//  Skaik_mo
//
//  GoSignInOrUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit
import FirebaseAuth

class GoSignInOrUpViewController: UIViewController {

    @IBOutlet weak var greenButton: GreenButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
    }

    @IBAction func goSignUpAction(_ sender: Any) {
        let vc: SignUpViewController = SignUpViewController._instantiateVC(storyboard: self._authStoryboard)
        vc._push()
    }


}

// MARK: - ViewDidLoad
extension GoSignInOrUpViewController {

    private func setUpViewDidLoad() {
        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            let vc: SignInViewController = SignInViewController._instantiateVC(storyboard: self._authStoryboard)
            vc._push()
        }
    }

}

// MARK: - ViewWillAppear
extension GoSignInOrUpViewController {

    private func setUpViewWillAppear() {
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
    }

}

