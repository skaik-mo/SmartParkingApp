//
//  MainNavigationViewController.swift
//
//
//  Created by Mohammed Skaik on 07/03/2022.
//
import UIKit

class MainNavigationController: UINavigationController {

    let appearance = UINavigationBarAppearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDidLoad()

    }

}

// MARK: - ViewDidLoad
extension MainNavigationController {

    private func setupViewDidLoad() {
        AppDelegate.shared?.rootNavigationController = self
        setRoot()
        setProperties()
    }

}

extension MainNavigationController {

    private func setRoot() {
        let auth = AuthManager.shared.getLocalAuth()
        switch auth?.typeAuth {
        case .User:
            let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
            vc._rootPush()
        case .Business:
            let vc: HomeBusinessViewController = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
            vc._rootPush()
        case .none:
            let vc = GoSignInOrUpViewController._instantiateVC(storyboard: self._authStoryboard)
            vc._rootPush()
        }
    }

    private func setProperties() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: "000000"._hexColor, NSAttributedString.Key.font: fontMontserratRegular17 ?? UIFont.systemFont(ofSize: 17, weight: .regular)]

        appearance.titleTextAttributes = titleTextAttributes
        setTransparentNavigation()
        self.navigationBar.titleTextAttributes = titleTextAttributes
    }

    func setTransparentNavigation() {
        appearance.configureWithTransparentBackground()
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance

    }

    func setWhiteNavigation() {
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

}
