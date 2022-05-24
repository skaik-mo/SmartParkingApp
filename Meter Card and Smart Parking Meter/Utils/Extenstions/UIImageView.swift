//
//  UIImageView.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/05/2022.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func fetchImage(_ urlStr: String?, _ placeholder: String? = "ic_placeholderPerson") {
        if let url = urlStr, !url.isEmpty {
            self.sd_setImage(with: URL(string: url), placeholderImage: placeholder?._toImage,
                options: .queryMemoryData, completed: nil)
        } else {
            image = placeholder?._toImage
        }
    }
    
    func fetchImageWithActivityIndicator(_ urlStr: String?, _ placeholder: String? = "ic_placeholderParking") {
        sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        self.fetchImage(urlStr, placeholder)
    }
}
