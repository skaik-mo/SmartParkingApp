//
//  UITextField.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UITextField {

    @IBInspectable var paddingLeftCustom: CGFloat {
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
        get {
            return leftView!.frame.size.width
        }
    }

    @IBInspectable var paddingRightCustom: CGFloat {
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
        get {
            return rightView!.frame.size.width
        }
    }

    var _placeholderColor: UIColor {
        set {
            self.attributedPlaceholder = NSAttributedString(
                string: self.attributedPlaceholder?.string ?? "Text",
                attributes: [NSAttributedString.Key.foregroundColor: newValue]
            )
        }
        get {
            return .gray
        }
    }

}
