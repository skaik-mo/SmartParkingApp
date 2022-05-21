//
//  UIResponder.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIResponder {
    static var _id: String {
        return String(describing: self)
    }
    
    var _authStoryboard: UIStoryboard {
        return UIStoryboard.init(name: "Auth", bundle: nil)
    }
    
    var _accountStoryboard: UIStoryboard {
        return UIStoryboard.init(name: "Account", bundle: nil)
    }
    
    var _userStoryboard: UIStoryboard {
        return UIStoryboard.init(name: "User", bundle: nil)
    }
    
    var _businessStoryboard: UIStoryboard {
        return UIStoryboard.init(name: "Business", bundle: nil)
    }
    
    var _topVC: UIViewController? {
        return AppDelegate.shared?.rootNavigationController?.topViewController
    }
    
}
