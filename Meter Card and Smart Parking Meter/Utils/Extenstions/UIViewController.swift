//
//  UIViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIViewController {

    class var _storyborad: UIViewController {
        if let vc = UIStoryboard._mainStoryboard.instantiateVC(withIdentifier: self._id) {
            return vc
        }
        return UIViewController()
    }

    var _screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    var _screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    var _isHideNavigation: Bool {
        set {
            self.navigationController?.setNavigationBarHidden(newValue, animated: true)
        }
        get {
            return self.navigationController?.isNavigationBarHidden ?? false
        }
    }

    var _topMostViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?._topMostViewController
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController._topMostViewController
            }
            return tabBarController._topMostViewController
        }

        else if let presentedViewController = self.presentedViewController {
            return presentedViewController._topMostViewController
        }

        else {
            return self
        }
    }

    func _getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }

    func _setTitleBackBarButton() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = "000000"._hexColor
    }
    
    class func _push(_ handle: ((_ viewController: UIViewController) -> Void)? = nil) {
        let vc = Self._storyborad
        handle?(vc)
        AppDelegate.shared?.rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    class func _rootPush() {
        AppDelegate.shared?.rootNavigationController?.setViewControllers([Self._storyborad], animated: true)
    }

    class func _presentVC(_ handle: ((_ viewController: UIViewController) -> Void)? = nil) {
        let vc = Self._storyborad
        handle?(vc)
        AppDelegate.shared?.rootNavigationController?.present(vc, animated: true, completion: nil)
    }
    
    func _pop() {
        AppDelegate.shared?.rootNavigationController?.popViewController(animated: true)
    }

    func _presentVC() {
        AppDelegate.shared?.rootNavigationController?.present(self, animated: true, completion: nil)
    }

    func _dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    func _showAlertOKAndCancel(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default) { action in
            debugPrint("Okay aciton is pressed")
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { action in
            debugPrint("Cancel aciton is pressed")
        }
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        alert._presentVC()
    }

    func _showAlertOK(message: String?) {
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)

        alert.addAction(okayAction)
        alert._presentVC()
    }

    func _showErrorAlertWithTitle(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)

        alert.addAction(okayAction)
        alert._presentVC()
    }

    func _showErrorAlert(message: String?) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)

        alert.addAction(okayAction)
        alert._presentVC()
    }

    func _showAlert(title: String?, message: String?, buttonAction1: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default) { action in
            debugPrint("Okay aciton is pressed")
            buttonAction1()
        }
        alert.addAction(okayAction)
        alert._presentVC()
    }

    func _showAlert(title: String?, message: String?, buttonTitle1: String = "OK", buttonTitle2: String = "Cancel", buttonAction1: @escaping (() -> Void), buttonAction2: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: buttonTitle1, style: .default) { action in
            debugPrint("Okay aciton is pressed")
            buttonAction1()
        }
        let cancelAction = UIAlertAction.init(title: buttonTitle2, style: .cancel) { action in
            debugPrint("Cancel aciton is pressed")
            buttonAction2()
        }
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        alert._presentVC()
    }

    @IBAction func _popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func _popViewControllerWithoutAnimated(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func _dismissViewController(_ sender: Any) {
        self._dismissVC()
    }

    @IBAction func _dismissViewControllerWithoutAnimated(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

//    public static func _isEmailValid(emailAddress:String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: emailAddress)
//    }
//
//    public static func _isPasswordValid(password: String) -> Bool {
//        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
//
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
//        return passwordTest.evaluate(with: password)
//    }

}
