//  Skaik_mo
//
//  SelectDateOrTime.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/03/2022.
//

import UIKit

class SelectDateOrTime: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var toImageView: UIImageView!
    
    enum SelectionType {
        case date
        case time
    }

    var selectionType: SelectionType = .date {
        didSet {
            setUpView()
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
        Bundle.main.loadNibNamed(SelectDateOrTime._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

}

extension SelectDateOrTime {
    func setUpView() {
        if selectionType == .date {
            setDate()
            return
        }
        setTime()
    }

    func setDate() {
        self.title.text = "Select the appropriate date"
        fromImageView.image = "ic_calendar"._toImage
        toImageView.image = "ic_calendar"._toImage
    }

    func setTime() {
        self.title.text = "Select the appropriate Time"
        fromImageView.image = "ic_clock"._toImage
        toImageView.image = "ic_clock"._toImage

    }
}
