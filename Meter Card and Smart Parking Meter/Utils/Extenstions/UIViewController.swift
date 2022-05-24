//
//  UIViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

//    class func _push22<T: UIViewController>(_ storyboard: UIStoryboard? = nil, _ handle: ((_ viewController: T) -> Void)? = nil) {
//        guard let vc = storyboard?.instantiateVC(withIdentifier: self._id) as? T else {
//            fatalError("Couldn't find UIViewController for \(self._id), make sure the view controller is created")
//        }
//
//        handle?((storyboard?.instantiateVC(withIdentifier: self._id) as? T)!)
//        AppDelegate.shared?.rootNavigationController?.pushViewController(vc, animated: true)
//    }

//**********************<< Transfers Shortcuts >>**********************
extension UIViewController {

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

    class func _instantiateVC<T: UIViewController>(storyboard: UIStoryboard) -> T {
        guard let vc = storyboard.instantiateVC(withIdentifier: self._id) as? T else {
            fatalError("Couldn't find UIViewController for \(self._id), make sure the view controller is created")
        }
        return vc

    }

    func _rootPush() {
        AppDelegate.shared?.rootNavigationController?.setViewControllers([self], animated: true)
    }

    func _push() {
        AppDelegate.shared?.rootNavigationController?.pushViewController(self, animated: true)
    }

    func _presentVC() {
        AppDelegate.shared?.rootNavigationController?.present(self, animated: true, completion: nil)
    }

    func _pop() {
        AppDelegate.shared?.rootNavigationController?.popViewController(animated: true)
    }

    func _dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    func _presentTopToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.window?.layer.add(transition, forKey: kCATransition)
    }

    func _dismissTopToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
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

}

//**********************<< Alerts Shortcuts >>**********************
extension UIViewController {
    func _showAlertOKWithTitle(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .default)
        alert.addAction(okayAction)
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
        let okayAction = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)

        alert.addAction(okayAction)
        alert._presentVC()
    }

    func _showErrorAlert(message: String?) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)

        alert.addAction(okayAction)
//        alert._presentVC()
        self.present(alert, animated: true, completion: nil)
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

    func _showAlert(title: String?, message: String?, buttonTitle1: String = "OK", buttonTitle2: String = "Cancel", buttonAction1: @escaping (() -> Void), buttonAction2: (() -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: buttonTitle1, style: .default) { action in
            debugPrint("Okay aciton is pressed")
            buttonAction1()
        }
        let cancelAction = UIAlertAction.init(title: buttonTitle2, style: .cancel) { action in
            debugPrint("Cancel aciton is pressed")
            buttonAction2?()
        }
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        alert._presentVC()
    }
}

extension UIViewController {

    var _getStatusBarHeightBottom: CGFloat? {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom
    }

    var _getStatusBarHeightTop: CGFloat? {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top
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

    func _setTitleBackBarButton() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = "000000"._hexColor
    }

    func _addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardNotifications(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardNotifications(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardNotifications(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func _removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func _keyboardNotifications(notification: NSNotification) {

        guard let keyBoardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        debugPrint(" *********************************** ")
        if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
            if let statusBar = self._getStatusBarHeightBottom, view.frame.origin.y == 0 {
                self.view.frame.origin.y = statusBar - keyBoardFrame.height
                debugPrint("view \(self.view.frame.origin.y) keyBoardFrame \(keyBoardFrame.height) statusBar \(statusBar)")
                return
            }
            debugPrint(" \(self.view.frame.origin.y)  \(keyBoardFrame.height) ")
            self.view.frame.origin.y = -keyBoardFrame.height
        } else {

            self.view.frame.origin.y = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dates(from fromDate: String, to toDate: String) -> [String] {
        guard let _fromDate = fromDate._toDate, let _toDate = toDate._toDate else { return [] }
        var dates: [String] = []
        var date = _fromDate

        while date <= _toDate {
            dates.append(date._stringData)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
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
