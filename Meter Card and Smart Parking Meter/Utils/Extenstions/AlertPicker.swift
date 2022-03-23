//
//  AlertPicker.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import Foundation
import UIKit

extension UIAlertController {

    func _show() {
        AppDelegate.shared?.rootNavigationController?.visibleViewController?.present(self, animated: true, completion: nil)
    }

    func _present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = AppDelegate.shared?.rootNavigationController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }

    private func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController {
                presentFromController(visibleVC, animated: animated, completion: completion)
        } else {
          if  let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController {
                presentFromController(selectedVC, animated: animated, completion: completion)
          } else {
              controller.present(self, animated: animated, completion: completion)
          }
        }
    }
}
