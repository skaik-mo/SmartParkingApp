//
//  SKActivityIndicator.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 18/05/2022.
//

import Foundation
import SKActivityIndicatorView

extension SKActivityIndicator {
    
    class func showIndicator(){
        SKActivityIndicator.show("", userInteractionStatus: false)
        SKActivityIndicator.spinnerColor("3FBF66"._hexColor)
        SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
    }
    
    class func dismissIndicator() {
        SKActivityIndicator.dismiss()
    }
}
