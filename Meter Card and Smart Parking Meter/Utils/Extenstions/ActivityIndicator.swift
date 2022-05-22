//
//  ActivityIndicator.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 18/05/2022.
//

import Foundation
import ProgressHUD

extension ProgressHUD {

    class func showIndicator() {
        ProgressHUD.show(interaction: false)
        ProgressHUD.colorAnimation = "3FBF66"._hexColor
        ProgressHUD.animationType = .circleSpinFade
    }

    class func dismissIndicator() {
        ProgressHUD.dismiss()
    }
}
