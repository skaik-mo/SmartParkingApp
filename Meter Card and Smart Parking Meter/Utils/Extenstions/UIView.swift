//
//  UIView.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return .gray
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable var shadowColor: UIColor {
        set {
            self.layer.shadowColor = newValue.cgColor
        }
        get {
            return .gray

        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }
        get {
            return self.layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }
        get {
            return self.layer.shadowRadius
        }
    }
    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }
        get {
            return self.layer.shadowOpacity
        }
    }

    var toImage: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

//    func _roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.frame = bounds
//        mask.path = path.cgPath
//        layer.mask = mask
//        layer.masksToBounds = false
//    }

    func _roundCorners(isTopLeft: Bool = false, isTopRight: Bool = false, isBottomLeft: Bool = false, isBottomRight: Bool = false, radius: CGFloat) {
        var corners: CACornerMask = []


        var isTopLeftCorner: Bool = isTopLeft
        var isTopRightCorner: Bool = isTopRight
        var isBottomLeftCorner: Bool = isBottomLeft
        var isBottomRightCorner: Bool = isBottomRight

        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            let tl = isTopLeftCorner
            let tr = isTopRightCorner
            let bl = isBottomLeftCorner
            let br = isBottomRightCorner

            isTopLeftCorner = tr
            isTopRightCorner = tl
            isBottomLeftCorner = br
            isBottomRightCorner = bl
        }
        if isTopLeftCorner {
            corners.insert(.layerMinXMinYCorner)
        }

        if isTopRightCorner {
            corners.insert(.layerMaxXMinYCorner)
        }
        if isBottomLeftCorner {
            corners.insert(.layerMinXMaxYCorner)
        }
        if isBottomRightCorner {
            corners.insert(.layerMaxXMaxYCorner)
        }
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }

    func _dismissView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self._dismiss))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc private func _dismiss() {
        AppDelegate.shared?.rootNavigationController?.topViewController?._dismissVC()
    }

}

