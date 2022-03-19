//
//  UIButton.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable var selectedImage: UIImage? {
        set{
            self.setImage(newValue, for: .selected)
        }
        get{
            return self.image(for: .normal)
        }
    }
    
    func _setAttributedString(rang: String, attributed: [NSAttributedString.Key : Any]) {
        guard let _currentTitle = self.currentTitle else { return }
        let attrStri = NSMutableAttributedString.init(string: _currentTitle)
        let nsRange = NSString(string: _currentTitle).range(of: rang, options: String.CompareOptions.caseInsensitive)

        attrStri.addAttributes(attributed, range: nsRange)
        self.setAttributedTitle(attrStri, for: .normal)
    }
    
    func _underline() {
        guard let title = self.titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: tittleText.count ))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

