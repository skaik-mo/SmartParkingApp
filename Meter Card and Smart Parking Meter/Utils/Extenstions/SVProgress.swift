//
//  SVProgress.swift
//  Test
//
//  Created by Mohammed Skaik on 26/01/2022.
//

import Foundation
import SVProgressHUD

extension SVProgressHUD {
    
    class func showSVProgress(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor("3FBF66"._hexColor)
        SVProgressHUD.setBackgroundColor("F4F7F5"._hexColor)
        SVProgressHUD.show()
    }
    
    class func showProgress(_ progress: Float) {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor("3FBF66"._hexColor)
        SVProgressHUD.setBackgroundColor("F4F7F5"._hexColor)
        SVProgressHUD.showProgress(progress)
    }
    
}

