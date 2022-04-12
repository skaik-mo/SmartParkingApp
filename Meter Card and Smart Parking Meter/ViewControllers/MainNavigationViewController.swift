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
        let vc: UIViewController
        switch AuthManager.shared.getLocalAuth().typeAuth {
        case .User:
            vc = HomeUserViewController._instantiateVC(storyboard: self._userStoryboard)
        case .Business:
            vc = HomeBusinessViewController._instantiateVC(storyboard: self._businessStoryboard)
        case .none:
            vc = GoSignInOrUpViewController._instantiateVC(storyboard: self._authStoryboard)
        }
        vc._rootPush()
    }

    func setProperties() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: "000000"._hexColor, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)]

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

//
//extension UIView {
// var hairlineImageView: UIImageView? {
//    return hairlineImageView(in: self)
//}
//
//fileprivate func hairlineImageView(in view: UIView) -> UIImageView? {
//    if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
//        return imageView
//    }
//
//    for subview in view.subviews {
//        if let imageView = self.hairlineImageView(in: subview) { return imageView }
//    }
//    return nil
//  }
//}
