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
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func goSignUpAction(_ sender: Any) {
        let vc: SignUpViewController = SignUpViewController._instantiateVC(storyboard: self._authStoryboard)
        vc._push()
    }
    

}

extension GoSignInOrUpViewController {

    func setupView() {
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
        self.greenButton.setUp(typeButton: .greenButton)
        self.greenButton.handleButton = {
            let vc: SignInViewController = SignInViewController._instantiateVC(storyboard: self._authStoryboard)
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

