//
//  MainNavigationViewController.swift
//
//
//  Created by Mohammed Skaik on 07/03/2022.
//
import UIKit

class MainNavigationController: UINavigationController {

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

}

extension MainNavigationController {

    func setupView() {
        AppDelegate.shared?.rootNavigationController = self

        setRoot()
        setProperties()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension MainNavigationController {
    
    func setRoot() {
        GoSignInOrUpViewController._rootPush()
    }

    func setProperties() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: "000000"._hexColor, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = titleTextAttributes
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.titleTextAttributes = titleTextAttributes

    }

}



