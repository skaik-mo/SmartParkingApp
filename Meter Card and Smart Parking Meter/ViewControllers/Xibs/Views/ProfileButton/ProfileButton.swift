//  Skaik_mo
//
//  ProfileButton.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 21/03/2022.
//

import UIKit

class ProfileButton: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var nameButton: String? {
        set{
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
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
        Bundle.main.loadNibNamed(ProfileButton._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

    @IBAction func action(_ sender: Any) {
        self.handleButton?()
    }
    
    
}
