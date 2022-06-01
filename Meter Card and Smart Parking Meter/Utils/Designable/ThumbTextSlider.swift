//
//  ThumbTextSlider.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/03/2022.
//

import Foundation
import UIKit

class ThumbTextSlider: UISlider {

    private var thumbTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = "5F5D70"._hexColor
        label.font = fontMontserratRegular14
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var thumbView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: thumbFrame.height)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.isUserInteractionEnabled = false
        return view
    }()

    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }

    var width: CGFloat = 64

    override func layoutSubviews() {
        super.layoutSubviews()
        
        subView.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.origin.y, width: width, height: thumbFrame.height)
        thumbTextLabel.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.origin.y, width: width, height: thumbFrame.height)
        self.setValue()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(subView)
        addSubview(thumbTextLabel)
        setThumbImage(thumbView.toImage, for: .normal)
    }

    private func setValue() {
        thumbTextLabel.text = self.value._toString + " km"
    }

}
