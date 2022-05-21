//  Skaik_mo
//
//  SpotCollectionViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 17/05/2022.
//

import UIKit

class SpotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var spotButton: UIButton!

    var numberOfSpot: Int?

    var typeSpotButton: TypeSpotButton = .border {
        didSet {
            self.switchTypeButton()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        if let _number = self.numberOfSpot {
            self.spotButton.setTitle("P\(_number + 1)", for: .normal)
        }
    }

}

extension SpotCollectionViewCell {

    private func switchTypeButton() {
        switch self.typeSpotButton {
        case .border:
            self.setButton(borderColor: "3FBF66"._hexColor, backgroundColor: .clear, titleColor: .black, isEnable: false)
            break
        case .selectedFill:
            self.setButton(borderColor: .clear, backgroundColor: "E5E5E5"._hexColor, titleColor: .black, isEnable: true)
            break
        case .unselectedfill:
            self.setButton(borderColor: .clear, backgroundColor: "E5E5E5"._hexColor, titleColor: .black, isEnable: false)
            break
        case .grayWithBorder:
            self.setButton(borderColor: "ECECEC"._hexColor, backgroundColor: .clear, titleColor: "929292"._hexColor, isEnable: false)
            break
        }
    }

    private func setButton(borderColor: UIColor, backgroundColor: UIColor, titleColor: UIColor, isEnable: Bool) {
        self.spotButton.borderColor = borderColor
        self.spotButton.backgroundColor = backgroundColor
        self.spotButton.setTitleColor(titleColor, for: .normal)
        setEnable(isEnable: isEnable)
    }

    func selectedAction() {
        self.setButton(borderColor: .clear, backgroundColor: "3FBF66"._hexColor, titleColor: .white, isEnable: true)
    }
    
    func unSelectedAction() {
        self.setButton(borderColor: .clear, backgroundColor: "E5E5E5"._hexColor, titleColor: .black, isEnable: true)
    }

    func setEnable(isEnable: Bool) {
        self.isUserInteractionEnabled = isEnable
    }

}

