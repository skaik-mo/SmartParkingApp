//  Skaik_mo
//
//  GoSignInOrUpViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

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
        SignUpViewController._push()
    }
    

}

extension GoSignInOrUpViewController {

    func setupView() {
        self.greenButton.handleButton = {
            SignInViewController._push()
        }
        
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

