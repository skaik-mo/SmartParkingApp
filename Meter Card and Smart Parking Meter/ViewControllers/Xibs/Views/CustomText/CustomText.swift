//  Skaik_mo
//
//  CustomText.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import UIKit

class CustomText: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraImage: UIImageView!

    @IBInspectable var placeholder: String? {
        set {
            self.textField.placeholder = newValue
        }
        get {
            return self.textField.placeholder
        }
    }

    var keyboardType: UIKeyboardType {
        set {
            self.textField.keyboardType = newValue
        }
        get {
            return .default
        }
    }

    var isPassword: Bool {
        set {
            self.textField.isSecureTextEntry = newValue
        }
        get {
            return false
        }
    }

    var showCameraIcon: Bool {
        set {
            self.cameraButton.isHidden = !newValue
            self.cameraImage.isHidden = !newValue
            self.textField.isEnabled = !newValue
        }
        get {
            return false
        }
    }

    var text: String {
        set {
            self.textField.text = newValue
        }
        get {
            return self.textField._getText
        }
    }

    var isSelectedText = false {
        didSet {
            switchColor()
        }
    }

    var handleAddImage: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
        setUpView()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(CustomText._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

    private func setUpView() {
        textField._placeholderColor = "000000"._hexColor
        self.cameraButton.isHidden = true
        self.cameraImage.isHidden = true

    }

    private func switchColor() {
        switch self.isSelectedText{
        case true:
            fieldSelected()
        case false:
            fieldUnselected()
        }
    }
    
    private func fieldSelected() {
        self.contentView.backgroundColor = "EFFFF4"._hexColor
        self.lineView.backgroundColor = "3FBF66"._hexColor
    }

    private func fieldUnselected() {
        self.contentView.backgroundColor = "FAFAFA"._hexColor
        self.lineView.backgroundColor = "EFEFEF"._hexColor
    }

    @IBAction func setGreenBackground(_ sender: Any) {
        self.isSelectedText = true
    }

    @IBAction func setGrayBackground(_ sender: Any) {
        self.isSelectedText = false
    }


    @IBAction func addImageAction(_ sender: Any) {
        handleAddImage?()
    }

}
