//  Skaik_mo
//
//  GreenButton.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

class GreenButton: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var greenButton: UIButton!

    @IBInspectable var nameButton: String? {
        set{
            self.greenButton.setTitle(newValue, for: .normal)
        }
        get {
            return self.greenButton.currentTitle
        }
    }
    
    enum TypeButton {
        case greenButton
        case redButton
        case grayButton
        case grayButtonWithBorder
    }
    
    private var typeButton: TypeButton = .greenButton {
        didSet {
            setUpButton()
        }
    }
    
    var handleButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(GreenButton._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

    
    @IBAction func greenButtonAction(_ sender: Any) {
        self.handleButton?()
    }
    
}

extension GreenButton {
    
    func setUp(typeButton: TypeButton, corner: CGFloat = 10) {
        self.typeButton = typeButton
        self.greenButton.layer.cornerRadius = corner
    }
    
    private func setUpButton() {
        switch self.typeButton {
        case .greenButton:
            self.greenButton.backgroundColor = "3FBF66"._hexColor
            self.greenButton.setTitleColor(.white, for: .normal)
            self.greenButton.layer.borderWidth = 0
            self.greenButton.layer.borderColor = UIColor.clear.cgColor
        case .redButton:
            self.greenButton.backgroundColor = "D0021B"._hexColor
            self.greenButton.setTitleColor(.white, for: .normal)
            self.greenButton.layer.borderWidth = 0
            self.greenButton.layer.borderColor = UIColor.clear.cgColor
        case .grayButtonWithBorder:
            self.greenButton.backgroundColor = "FAFAFA"._hexColor
            self.greenButton.setTitleColor(.black, for: .normal)
            self.greenButton.layer.borderWidth = 1
            self.greenButton.layer.borderColor = "E2E2E2"._hexColor.cgColor
        case .grayButton:
            self.greenButton.backgroundColor = "E5E5E5"._hexColor
            self.greenButton.setTitleColor(.black, for: .normal)
            self.greenButton.layer.borderWidth = 0
            self.greenButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
