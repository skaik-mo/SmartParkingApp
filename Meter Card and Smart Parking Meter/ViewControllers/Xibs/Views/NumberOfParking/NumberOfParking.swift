//  Skaik_mo
//
//  NumberOfParking.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import UIKit

class NumberOfParking: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p3Button: UIButton!
    @IBOutlet weak var p4Button: UIButton!
    @IBOutlet weak var p5Button: UIButton!
    @IBOutlet weak var p6Button: UIButton!
    @IBOutlet weak var p7Button: UIButton!


    enum TypeParkingView {
        case border
        case fill
        case grayWithBorder
    }

    var typeParkingView: TypeParkingView = .border {
        didSet {
            switchTypeParkingView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(NumberOfParking._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()

    }

    @IBAction func p1Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p2Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p3Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p4Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p5Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p6Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }

    @IBAction func p7Action(_ sender: UIButton) {
        selectedAction(button: sender)
    }


}

extension NumberOfParking {

    private func switchTypeParkingView() {
        
        switch self.typeParkingView {
        case .border:
            setBorderColor(color: "3FBF66"._hexColor)
            setBackgroundColor(backgroundColor: .clear, tintColor: .black)
            setEnable(isEnable: false)
        case .fill:
            setBorderColor(color: .clear)
            setBackgroundColor(backgroundColor: "E5E5E5"._hexColor, tintColor:  .black)
            setEnable(isEnable: true)
        case .grayWithBorder:
            setBorderColor(color: "ECECEC"._hexColor)
            setBackgroundColor(backgroundColor: .clear, tintColor: "929292"._hexColor)
            setEnable(isEnable: false)
        }
        
    }

    private func setBorderColor(color: UIColor) {
        self.p1Button.borderColor = color
        self.p2Button.borderColor = color
        self.p3Button.borderColor = color
        self.p4Button.borderColor = color
        self.p5Button.borderColor = color
        self.p6Button.borderColor = color
        self.p7Button.borderColor = color

    }

    private func setBackgroundColor(backgroundColor: UIColor, tintColor: UIColor) {
        self.p1Button.backgroundColor = backgroundColor
        self.p1Button.tintColor = tintColor

        self.p2Button.backgroundColor = backgroundColor
        self.p2Button.tintColor = tintColor

        self.p3Button.backgroundColor = backgroundColor
        self.p3Button.tintColor = tintColor

        self.p4Button.backgroundColor = backgroundColor
        self.p4Button.tintColor = tintColor

        self.p5Button.backgroundColor = backgroundColor
        self.p5Button.tintColor = tintColor

        self.p6Button.backgroundColor = backgroundColor
        self.p6Button.tintColor = tintColor

        self.p7Button.backgroundColor = backgroundColor
        self.p7Button.tintColor = tintColor
    }

    func selectedAction(button: UIButton) {
        if typeParkingView == .fill {
            setBackgroundColor(backgroundColor: "E5E5E5"._hexColor, tintColor: .black )
            button.backgroundColor = "3FBF66"._hexColor
            button.tintColor = .white
        }
    }

    func setEnable(isEnable: Bool) {
        p1Button.isUserInteractionEnabled = isEnable
        p2Button.isUserInteractionEnabled = isEnable
        p3Button.isUserInteractionEnabled = isEnable
        p4Button.isUserInteractionEnabled = isEnable
        p5Button.isUserInteractionEnabled = isEnable
        p6Button.isUserInteractionEnabled = isEnable
        p7Button.isUserInteractionEnabled = isEnable
    }

}
