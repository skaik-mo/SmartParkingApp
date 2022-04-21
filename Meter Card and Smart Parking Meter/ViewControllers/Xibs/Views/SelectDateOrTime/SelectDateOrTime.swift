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

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!

    enum SelectionType {
        case date
        case time
    }

    var selectionType: SelectionType = .date {
        didSet {
            setUpView()
        }
    }

    var isHiddenIcons: Bool = false {
        didSet {
            setIcons()
        }
    }

    var fromText: String {
        var value = ""
        if let _text = self.fromLabel.text {
            if _text.lowercased().contains("from") {
                value = ""
            } else {
                value = _text._removeWhiteSpace
            }
        }
        return value
    }

    var toText: String {
        var value = ""
        if let _text = self.toLabel.text {
            if _text.lowercased().contains("to") {
                value = ""
            } else {
                value = _text._removeWhiteSpace
            }
        }
        return value
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

    @IBAction func FromAction(_ sender: Any) {
        showDateOrTime { value in
            if let _value = value {
                self.fromLabel.text = _value
                self.isHiddenIcons = true
            }
        }
    }


    @IBAction func toAction(_ sender: Any) {
        showDateOrTime { value in
            if let _value = value {
                self.toLabel.text = _value
                self.isHiddenIcons = true
            }

        }
    }




}

extension SelectDateOrTime {
    func setIcons() {
        self.toImageView.isHidden = self.isHiddenIcons
        self.fromImageView.isHidden = self.isHiddenIcons
    }

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

    private func showDateOrTime(handle: @escaping (_ value: String?) -> Void) {
        let alert = UIAlertController(style: .actionSheet, title: "Select \(selectionType.self)")
        let date = Date()._add(months: 1)
        
        if self.selectionType == .date {
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: "2022-01-01"._toDate, maximumDate: date) { date in
                handle(date._stringData)
            }
        } else {
            alert.addDatePicker(mode: .time, date: Date(), minimumDate: "2022-01-01"._toDate, maximumDate: date) { time in
                handle(time._getTime())
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        alert._show()
    }

    func isEmptyFields() -> (status: Bool, errorMessage: String?) {
        if fromText._isValidValue, toText._isValidValue {
            return (false, nil)
        }
        return (true, "Enter \(selectionType) fields")
    }

}
